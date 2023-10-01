/** @type {import('tailwindcss').Config} */

module.exports = {
  content: {
    relative: true,
    files: [
      './app/views/**/*.html.slim',
      './app/views/**/*.html.erb',
      './app/components/**/*.html.{slim,erb}',
      './app/components/**/*.rb'
    ]
  },
  theme: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms')
  ],
}
