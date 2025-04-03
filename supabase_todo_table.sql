-- 创建todos表
CREATE TABLE IF NOT EXISTS public.todos (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    is_completed BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    color TEXT,
    due_date TIMESTAMPTZ,
    priority INTEGER DEFAULT 0
);

-- 为todos表添加RLS策略（行级安全）
ALTER TABLE public.todos ENABLE ROW LEVEL SECURITY;

-- 创建用户只能访问自己的todos的策略
CREATE POLICY "用户只能查看自己的todos" ON public.todos
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "用户只能插入自己的todos" ON public.todos
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "用户只能更新自己的todos" ON public.todos
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "用户只能删除自己的todos" ON public.todos
    FOR DELETE USING (auth.uid() = user_id);

-- 创建索引以提高查询性能
CREATE INDEX todos_user_id_idx ON public.todos(user_id);
CREATE INDEX todos_created_at_idx ON public.todos(created_at);
CREATE INDEX todos_is_completed_idx ON public.todos(is_completed);
CREATE INDEX todos_priority_idx ON public.todos(priority); 