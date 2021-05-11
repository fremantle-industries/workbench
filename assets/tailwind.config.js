const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  purge: [
    '../lib/**/*.ex',
    '../lib/**/*.leex',
    '../lib/**/*.eex',
    './js/**/*.js',
    './js/**/*.jsx',
    './js/**/*.ts',
    './js/**/*.tsx'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      fontFamily: {
        // Free Proxima Nova alternative
        sans: ['Montserrat', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  variants: {
    visibility: ['group-hover'],
    display: ['responsive', 'empty'],
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('tailwindcss-empty-pseudo-class')(),
  ],
}
