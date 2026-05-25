// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

let plugin = require('tailwindcss/plugin')

module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['"Helvetica Neue"', 'Helvetica', 'Arial', 'sans-serif'],
        serif: ['"Palatino Linotype"', 'Palatino', 'Garamond', 'Georgia', 'serif'],
        headline: ['Cambria', '"Hoefler Text"', 'Times', '"Times New Roman"', 'serif'],
      },
      typography: (theme) => ({
        DEFAULT: {
          css: {
            color: theme('colors.slate.900'),
            fontFamily: theme('fontFamily.sans').join(', '),
            a: {
              color: theme('colors.indigo.600'),
              '&:hover': {
                color: theme('colors.indigo.800'),
              },
            },
            h1: { color: theme('colors.slate.900'), fontFamily: theme('fontFamily.serif').join(', ') },
            h2: { color: theme('colors.slate.900'), fontFamily: theme('fontFamily.serif').join(', ') },
            h3: { color: theme('colors.slate.900'), fontFamily: theme('fontFamily.sans').join(', ') },
            h4: { color: theme('colors.slate.900'), fontFamily: theme('fontFamily.sans').join(', ') },
            strong: { color: theme('colors.slate.900') },
            blockquote: { 
              color: theme('colors.slate.900'),
              borderLeftColor: theme('colors.slate.300')
            },
            code: { color: theme('colors.slate.900') },
            pre: {
              color: theme('colors.slate.100'),
              backgroundColor: theme('colors.slate.800'),
            },
          },
        },
      }),
    },
  },
    plugins: [
        require('@tailwindcss/forms'),
        require('@tailwindcss/typography'),        
        plugin(({addVariant}) => addVariant('phx-no-feedback', ['&.phx-no-feedback', '.phx-no-feedback &'])),
        plugin(({addVariant}) => addVariant('phx-click-loading', ['&.phx-click-loading', '.phx-click-loading &'])),
        plugin(({addVariant}) => addVariant('phx-submit-loading', ['&.phx-submit-loading', '.phx-submit-loading &'])),
        plugin(({addVariant}) => addVariant('phx-change-loading', ['&.phx-change-loading', '.phx-change-loading &'])),
        require("daisyui")
  ]
}
