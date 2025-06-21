/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./components/**/*.{js,vue,ts}",
    "./layouts/**/*.vue",
    "./pages/**/*.vue",
    "./plugins/**/*.{js,ts}",
    "./app.vue",
    "./error.vue"
  ],
  theme: {
    extend: {
      colors: {
        primary: '#91C4F2',
        accent: '#A2E5C1', 
        warning: '#F27272',
        dark: '#28282B',
        cardBg: '#d0e2e8',
        pageBg: '#dfecf1'
      },
      fontFamily: {
        sans: ['Inter', 'sans-serif'],
        heading: ['Manrope', 'sans-serif'],
        inter: ['Inter', 'sans-serif'],
      },
      borderRadius: {
        xl: '1rem',
        '2xl': '1.5rem',
      },
      boxShadow: {
        card: '0 4px 20px rgba(0, 0, 0, 0.08)',
        'card-hover': '0 8px 32px rgba(0, 0, 0, 0.12)',
        subtle: '0 2px 8px rgba(0, 0, 0, 0.03)',
        glass: '0 8px 32px rgba(0, 0, 0, 0.3)',
        'glass-hover': '0 12px 40px rgba(0, 0, 0, 0.4)',
        floating: '0 20px 40px rgba(0, 0, 0, 0.3)',
        primary: '0 8px 32px rgba(145, 196, 242, 0.2)',
        'primary-hover': '0 12px 40px rgba(145, 196, 242, 0.3)',
        accent: '0 8px 32px rgba(162, 229, 193, 0.2)',
        'accent-hover': '0 12px 40px rgba(162, 229, 193, 0.3)',
      },
      backdropBlur: {
        xs: '2px',
      },
      backgroundImage: {
        'dark-gradient': 'linear-gradient(135deg, #010104 0%, #0a0a0f 50%, #010104 100%)',
        'dark-subtle': 'linear-gradient(135deg, #010104 0%, #0c0c12 100%)',
        'glass-gradient': 'linear-gradient(135deg, rgba(255, 255, 255, 0.05) 0%, rgba(255, 255, 255, 0.02) 100%)',
        'primary-gradient': 'linear-gradient(135deg, #91C4F2 0%, #7BB5EE 100%)',
        'accent-gradient': 'linear-gradient(135deg, #A2E5C1 0%, #8FDEB0 100%)',
        'primary-glass': 'linear-gradient(135deg, rgba(145, 196, 242, 0.2) 0%, rgba(123, 181, 238, 0.3) 100%)',
        'accent-glass': 'linear-gradient(135deg, rgba(162, 229, 193, 0.2) 0%, rgba(143, 222, 176, 0.3) 100%)',
      },
    },
  },
  plugins: [],
}