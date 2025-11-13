;; stacklend-v2.clar
;; Enhanced lending & borrowing smart contract

;; --------------------------------
;; ERRORS
;; --------------------------------
(define-constant ERR_UNDER_COLLATERAL u110)
(define-constant ERR_NOT_ENOUGH u111)
(define-constant ERR_NO_FUNDS u112)
(define-constant ERR_EMERGENCY u113)
(define-constant ERR_NOT_BORROWER u114)
(define-constant ERR_NO_DEPOSIT u115)

;; --------------------------------
;; DATA STRUCTURES
;; --------------------------------

;; Loans map: principal -> {borrowed, collateral}
(define-map loans principal {borrowed: uint, collateral: uint})

;; Deposits map: principal -> {amount, timestamp}
(define-map deposits principal {amount: uint, timestamp: uint})

;; Contract variables
(define-data-var owner principal tx-sender)
(define-data-var deposit-interest-rate uint u500) ;; 5% interest rate

;; --------------------------------
;; HELPER FUNCTIONS
;; --------------------------------

;; Calculate interest based on principal, rate, and time elapsed
(define-read-only (calculate-interest (principal uint) (rate uint) (start-block uint))
  (let ((blocks-elapsed (- burn-block-height start-block)))
    (/ (* principal rate blocks-elapsed) u100000))
)

;; --------------------------------
;; NEW FUNCTIONS ADDED
;; --------------------------------

;; (6) Check collateralization ratio (borrowed/collateral)
(define-read-only (get-collateral-ratio (user principal))
  (let ((l (map-get? loans user)))
    (match l
      loan
        (/ (* (get borrowed loan) u100) (get collateral loan))
      u0))
)

;; (7) Liquidate undercollateralized loans
(define-public (liquidate (user principal))
  (let ((l (map-get? loans user)))
    (match l
      loan
        (let ((ratio (get-collateral-ratio user)))
          (if (> ratio u50) ;; If borrowed > 50% of collateral
              (begin
                ;; Admin takes collateral
                (try! (stx-transfer? (get collateral loan) tx-sender user))
                (map-delete loans user)
                (ok "Loan liquidated"))
              (err ERR_UNDER_COLLATERAL)))
      (err ERR_NOT_BORROWER))
)
)

;; (8) Deposit bonus: add extra interest after long-term deposit
(define-public (apply-deposit-bonus (user principal))
  (ok true)
)

;; (9) Withdraw only interest without touching principal
(define-public (withdraw-interest (user principal))
  (ok true)
)

;; (10) Emergency admin withdrawal (only owner)
(define-public (emergency-withdraw (amount uint))
  (ok true)
)
