USE [DigitalLibraryDB]
GO
ALTER TABLE [dbo].[Borrow_Request] ADD expected_start_date DATE;
ALTER TABLE [dbo].[Borrow_Request] ADD expected_return_date DATE;
GO
