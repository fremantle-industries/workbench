module.exports = {
  mode: 'jit',
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
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}
