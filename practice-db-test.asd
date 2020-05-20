(defsystem "practice-db-test"
  :defsystem-depends-on ("prove-asdf")
  :author "ito"
  :license ""
  :depends-on ("practice-db"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "practice-db"))))
  :description "Test system for practice-db"
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
