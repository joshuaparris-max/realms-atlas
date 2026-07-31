$out = "C:\joshos-atlas-prep\raw-inventory"

gh repo list joshualparris --limit 200 --json name,nameWithOwner,url,visibility,description,isPrivate,updatedAt,pushedAt,primaryLanguage |
  Out-File "$out\github-repos-joshualparris.json" -Encoding utf8

gh repo list joshuaparris-max --limit 200 --json name,nameWithOwner,url,visibility,description,isPrivate,updatedAt,pushedAt,primaryLanguage |
  Out-File "$out\github-repos-joshuaparris-max.json" -Encoding utf8

gh repo list joshparri --limit 200 --json name,nameWithOwner,url,visibility,description,isPrivate,updatedAt,pushedAt,primaryLanguage |
  Out-File "$out\github-repos-joshparri.json" -Encoding utf8

Write-Host "Saved GitHub metadata exports to $out"
