(lang dune 2.0)

(name virtualization)

(license ISC)

(authors
  "Patrick Ferris")

(maintainers
  "Patrick Ferris")

(generate_opam_files true)

(package
 (name virtualization)
 (synopsis "Bindings to Apple's virtualization framework")
 (description "Bindings to Apple's virtualization framework")
 (depends
  (odoc :with-doc)))

(package
 (name virtu)
 (synopsis "Simple CLI tool for starting VMs")
 (description "Simple CLI tool for starting VMs")
 (depends
   virtualization
   cmdliner))
