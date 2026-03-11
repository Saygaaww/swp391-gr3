-- Khi seller Cancel/Refund đơn: thu hồi quyền sở hữu sách (theo order_id) và hoàn tồn kho.
-- Cột order_id cho biết quyền sở hữu được cấp từ đơn nào.
ALTER TABLE Reader_Book_Ownership ADD order_id INT NULL;
ALTER TABLE Reader_Book_Ownership ADD CONSTRAINT FK_Ownership_Order FOREIGN KEY (order_id) REFERENCES [Order](order_id);
GO
