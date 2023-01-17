/** @type {import('tailwindcss').Config} */

module.exports = {
  content: {
    relative: true,
    files: [
      './app/views/**/*.html.slim',
      './app/views/**/*.html.erb'
    ]
  },
  theme: {
    extend: {},
  },
  plugins: [],
}
