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
  (render-to-do))

(defroute ("/add-data" :method :POST) (&key |task|)
  (insert-data |task|)
  (render-to-do))

(defroute ("/delete-data" :method :POST) (&key |id|)
   (delete-data |id|)
   (render-to-do))

;;
;; Render

(defun render-to-do ()
  (render #P"index.html" `(:tasks ,(send-data))))

(defun send-data ()
  (with-connection (db)
    (retrieve-all
      (select :* (from :todo)))))

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
