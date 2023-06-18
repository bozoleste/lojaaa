-- Tabela para armazenar os itens da loja
CREATE TABLE items (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  quantity INT NOT NULL,
  price DECIMAL(10, 2) NOT NULL
);

-- Tabela para armazenar as informações financeiras da loja
CREATE TABLE finance (
  id INT PRIMARY KEY AUTO_INCREMENT,
  cash DECIMAL(10, 2) NOT NULL,
  sales DECIMAL(10, 2) NOT NULL
);