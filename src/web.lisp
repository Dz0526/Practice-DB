(in-package :cl-user)
(defpackage practice-db.web
  (:use :cl
        :caveman2
        :practice-db.config
        :practice-db.view
        :practice-db.db
        :datafly
        :sxql)
  (:export :*web*))
(in-package :practice-db.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules

(defroute "/" ()
  (render #P"index.html"))

;;
;; Database

(defun insert-data (data)
  (with-connection (db)
    (execute
      (insert-into :todo
        (set= :task data)))))

(defun delete-data (id)
  (with-connection (db)
    (execute
      (delete-from :todo
        (where (:= :id id))))))


(defun update-data (id data)
  (with-connection (db)
    (execute
      (update :todo
        (set= :task data)
        (where (:= :id id))))))

(defun show-table ()
  (with-connection (db)
    (let ((data (retrieve-all (select (:*) (from :todo)))))
      (dolist (n data)
        (format t "~{~A ~}~%" n))))) 
;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
