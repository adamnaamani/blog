# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@rails/actiontext", to: "https://ga.jspm.io/npm:@rails/actiontext@7.1.1/app/assets/javascripts/actiontext.js"
pin "trix", to: "https://ga.jspm.io/npm:trix@2.0.7/dist/trix.esm.min.js"
pin "highlight.js", to: "https://ga.jspm.io/npm:highlight.js@11.9.0/es/index.js"
