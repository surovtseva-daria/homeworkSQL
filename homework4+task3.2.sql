CREATE TABLE tx_accounts (
    account_id SERIAL PRIMARY KEY,
    account_name VARCHAR(100) NOT NULL UNIQUE,
    balance DECIMAL(10, 2) NOT NULL CHECK (balance >= 0)
);

INSERT INTO tx_accounts (account_name, balance) VALUES
('Alice', 1000.00),
('Bob', 500.00),
('Charlie', 300.00);
BEGIN;

-- Задание 1:
SELECT balance FROM tx_accounts WHERE account_id = 1 FOR UPDATE;

IF (SELECT balance FROM tx_accounts WHERE account_id = 1) >= 200 THEN

    UPDATE tx_accounts SET balance = balance - 200 WHERE account_id = 1;

    UPDATE tx_accounts SET balance = balance + 200 WHERE account_id = 2;
    
    -- Задание 2: 
    UPDATE tx_accounts SET balance = balance + 10 WHERE account_name = 'Alice';

    SAVEPOINT before_invalid_update;

    UPDATE tx_accounts SET balance = -100 WHERE account_name = 'Alice';

    ROLLBACK TO SAVEPOINT before_invalid_update;

    COMMIT; 
ELSE
    ROLLBACK; 
END IF;

-- Задание 3: Сравнение READ COMMITTED и REPEATABLE READ

REPEATABLE READ
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM tx_demo WHERE id = 1; 
