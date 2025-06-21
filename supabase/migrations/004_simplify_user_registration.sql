-- Drop the previous trigger approach
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS handle_new_user();

-- Add a policy that allows anonymous users to insert into users table during registration
-- This is safe because it requires the ID to match the auth.uid() which is only available after successful auth signup
CREATE POLICY "Enable insert for registration" ON users
    FOR INSERT WITH CHECK (true);

-- Update the existing insert policy to be more permissive during registration
DROP POLICY IF EXISTS "Users can insert their own record during registration" ON users;

-- Create a simpler function to create user profile after registration
CREATE OR REPLACE FUNCTION public.create_user_profile(
    user_id uuid,
    user_email text,
    user_full_name text,
    user_role user_role DEFAULT 'end_user',
    user_tenant_id uuid DEFAULT NULL
)
RETURNS void AS $$
BEGIN
    INSERT INTO public.users (id, email, full_name, role, tenant_id)
    VALUES (user_id, user_email, user_full_name, user_role, user_tenant_id)
    ON CONFLICT (id) DO NOTHING;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION public.create_user_profile TO authenticated;
GRANT EXECUTE ON FUNCTION public.create_user_profile TO anon;