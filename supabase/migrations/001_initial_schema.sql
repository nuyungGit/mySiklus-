-- ==============================================================================
-- SKRIP MIGRASI DATABASE: mySiklus
-- Target: PostgreSQL / Supabase
-- Fitur: users, cycles, fiqh_articles, search_logs, dan Row Level Security (RLS)
-- ==============================================================================

-- 1. TABEL PENGGUNA (Terkoneksi otomatis dengan Supabase Auth)
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()) NOT NULL
);

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view and edit their own profile"
    ON public.users FOR ALL
    USING (auth.uid() = id);

-- Trigger otomatis membuat data pengguna di public.users saat user mendaftar di auth.users
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.users (id, name, email)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'name', 'Muslimah'),
        NEW.email
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 2. TABEL SIKLUS (Pencatatan Haid dan Masa Suci)
CREATE TABLE IF NOT EXISTS public.cycles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    duration_haid INT NULL,
    notes TEXT NULL,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()) NOT NULL
);

ALTER TABLE public.cycles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage their own cycles"
    ON public.cycles FOR ALL
    USING (auth.uid() = user_id);

-- Index untuk mempercepat query riwayat siklus
CREATE INDEX IF NOT EXISTS idx_cycles_user_start_date ON public.cycles(user_id, start_date DESC);

-- 3. TABEL ARTIKEL FIQH (Basis Pengetahuan Terkurasi)
CREATE TABLE IF NOT EXISTS public.fiqh_articles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    category VARCHAR(50) NOT NULL CHECK (category IN ('Haid', 'Nifas', 'Istihadah', 'Masa Suci', 'Ibadah')),
    search_keywords TEXT NOT NULL,
    reference VARCHAR(255) NOT NULL,
    author_reviewer VARCHAR(150) DEFAULT 'Tim Asatidz / Fiqh Reviewer',
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()) NOT NULL
);

ALTER TABLE public.fiqh_articles ENABLE ROW LEVEL SECURITY;

-- Pengguna yang telah login hanya memiliki izin membaca artikel fiqh
CREATE POLICY "Public read-only access for fiqh articles"
    ON public.fiqh_articles FOR SELECT
    TO authenticated
    USING (true);

-- 4. TABEL LOG PENCARIAN (Instrumen Riset Skripsi Bab 4)
CREATE TABLE IF NOT EXISTS public.search_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    search_query TEXT NOT NULL,
    matched_article_id UUID REFERENCES public.fiqh_articles(id) ON DELETE SET NULL,
    similarity_score REAL NOT NULL,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc', NOW()) NOT NULL
);

ALTER TABLE public.search_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage their own search logs"
    ON public.search_logs FOR ALL
    USING (auth.uid() = user_id);
