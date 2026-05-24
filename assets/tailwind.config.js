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
      typography: (theme) => ({
        DEFAULT: {
          css: {
            color: theme('colors.slate.900'),
            a: {
              color: theme('colors.indigo.600'),
              '&:hover': {
                color: theme('colors.indigo.800'),
              },
            },
            h1: { color: theme('colors.slate.900') },
            h2: { color: theme('colors.slate.900') },
            h3: { color: theme('colors.slate.900') },
            h4: { color: theme('colors.slate.900') },
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
