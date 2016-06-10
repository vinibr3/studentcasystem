require 'zip'
# Permite rubyzip sobrescrever arquivos se eles já existem 
Zip.on_exists_proc = true
# Permite rubyzip sobrescrever arquivos no mesmo path ao criá-los
Zip.continue_on_exists_proc = true