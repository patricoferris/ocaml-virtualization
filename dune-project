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
  (ocaml (>= 4.08.0))
  dune
  (odoc :with-doc)
  ctypes))
