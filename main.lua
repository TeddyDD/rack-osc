fennel = require("fennel")
table.insert(package.loaders, fennel.make_searcher({correlate=true}))
pp = function(x) print(require("fennelview")(x)) end
-- lume = require("lib.lume")

require("wrap")
