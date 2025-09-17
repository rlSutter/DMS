-- =============================================
-- DMS (Document Management System) Database Schema
-- SQL Server DDL Script
-- Generated from analysis of DMS_Services codebase
-- =============================================

-- Create DMS Database
USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'DMS')
BEGIN
    CREATE DATABASE DMS;
END
GO

USE DMS;
GO

-- =============================================
-- Core Tables
-- =============================================

-- Documents table - Main document metadata
CREATE TABLE Documents (
    row_id INT IDENTITY(1,1) PRIMARY KEY,
    created DATETIME NOT NULL DEFAULT GETDATE(),
    created_by INT NOT NULL DEFAULT 1,
    last_upd DATETIME NOT NULL DEFAULT GETDATE(),
    last_upd_by INT NOT NULL DEFAULT 1,
    name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    dfilename NVARCHAR(255),
    ext_id NVARCHAR(50),
    data_type_id INT,
    last_version_id INT,
    deleted_flag CHAR(1) DEFAULT 'N',
    public_flag CHAR(1) DEFAULT 'N'
);

-- Document_Versions table - Document version control
CREATE TABLE Document_Versions (
    row_id INT IDENTITY(1,1) PRIMARY KEY,
    doc_id INT NOT NULL,
    created DATETIME NOT NULL DEFAULT GETDATE(),
    created_by INT NOT NULL DEFAULT 1,
    last_upd DATETIME NOT NULL DEFAULT GETDATE(),
    last_upd_by INT NOT NULL DEFAULT 1,
    backed_up DATETIME,
    dsize BIGINT,
    version INT NOT NULL DEFAULT 1,
    minio_flg CHAR(1) DEFAULT 'N',
    dimage VARBINARY(MAX),
    CONSTRAINT FK_Document_Versions_Documents FOREIGN KEY (doc_id) REFERENCES Documents(row_id)
);

-- Document_Types table - File type definitions
CREATE TABLE Document_Types (
    row_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    extension NVARCHAR(10) NOT NULL,
    mime_type NVARCHAR(100),
    created DATETIME NOT NULL DEFAULT GETDATE(),
    created_by INT NOT NULL DEFAULT 1,
    last_upd DATETIME NOT NULL DEFAULT GETDATE(),
    last_upd_by INT NOT NULL DEFAULT 1
);

-- Users table - System users
CREATE TABLE Users (
    row_id INT IDENTITY(1,1) PRIMARY KEY,
    ext_user_id NVARCHAR(50) NOT NULL UNIQUE,
    username NVARCHAR(100),
    email NVARCHAR(255),
    first_name NVARCHAR(100),
    last_name NVARCHAR(100),
    created DATETIME NOT NULL DEFAULT GETDATE(),
    created_by INT NOT NULL DEFAULT 1,
    last_upd DATETIME NOT NULL DEFAULT GETDATE(),
    last_upd_by INT NOT NULL DEFAULT 1,
    active_flag CHAR(1) DEFAULT 'Y'
);

-- Groups table - User groups for access control
CREATE TABLE Groups (
    row_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255),
    created DATETIME NOT NULL DEFAULT GETDATE(),
    created_by INT NOT NULL DEFAULT 1,
    last_upd DATETIME NOT NULL DEFAULT GETDATE(),
    last_upd_by INT NOT NULL DEFAULT 1,
    active_flag CHAR(1) DEFAULT 'Y'
);

-- Associations table - Document association types
CREATE TABLE Associations (
    row_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255),
    created DATETIME NOT NULL DEFAULT GETDATE(),
    created_by INT NOT NULL DEFAULT 1,
    last_upd DATETIME NOT NULL DEFAULT GETDATE(),
    last_upd_by INT NOT NULL DEFAULT 1,
    active_flag CHAR(1) DEFAULT 'Y'
);

-- Categories table - Document categories
CREATE TABLE Categories (
    row_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255),
    created DATETIME NOT NULL DEFAULT GETDATE(),
    created_by INT NOT NULL DEFAULT 1,
    last_upd DATETIME NOT NULL DEFAULT GETDATE(),
    last_upd_by INT NOT NULL DEFAULT 1,
    active_flag CHAR(1) DEFAULT 'Y'
);

-- Keywords table - Document keywords/tags
CREATE TABLE Keywords (
    row_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255),
    created DATETIME NOT NULL DEFAULT GETDATE(),
    created_by INT NOT NULL DEFAULT 1,
    last_upd DATETIME NOT NULL DEFAULT GETDATE(),
    last_upd_by INT NOT NULL DEFAULT 1,
    active_flag CHAR(1) DEFAULT 'Y'
);

-- =============================================
-- Relationship Tables
-- =============================================

-- Document_Associations table - Links documents to external entities
CREATE TABLE Document_Associations (
    row_id INT IDENTITY(1,1) PRIMARY KEY,
    doc_id INT NOT NULL,
    association_id INT NOT NULL,
    fkey NVARCHAR(100) NOT NULL,
    pr_flag CHAR(1) DEFAULT 'N',
    access_flag CHAR(1) DEFAULT 'N',
    reqd_flag CHAR(1) DEFAULT 'N',
    expiration DATETIME,
    created DATETIME NOT NULL DEFAULT GETDATE(),
    created_by INT NOT NULL DEFAULT 1,
    last_upd DATETIME NOT NULL DEFAULT GETDATE(),
    last_upd_by INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Document_Associations_Documents FOREIGN KEY (doc_id) REFERENCES Documents(row_id),
    CONSTRAINT FK_Document_Associations_Associations FOREIGN KEY (association_id) REFERENCES Associations(row_id)
);

-- Document_Categories table - Links documents to categories
CREATE TABLE Document_Categories (
    row_id INT IDENTITY(1,1) PRIMARY KEY,
    doc_id INT NOT NULL,
    cat_id INT NOT NULL,
    pr_flag CHAR(1) DEFAULT 'N',
    created DATETIME NOT NULL DEFAULT GETDATE(),
    created_by INT NOT NULL DEFAULT 1,
    last_upd DATETIME NOT NULL DEFAULT GETDATE(),
    last_upd_by INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Document_Categories_Documents FOREIGN KEY (doc_id) REFERENCES Documents(row_id),
    CONSTRAINT FK_Document_Categories_Categories FOREIGN KEY (cat_id) REFERENCES Categories(row_id)
);

-- Document_Keywords table - Links documents to keywords
CREATE TABLE Document_Keywords (
    row_id INT IDENTITY(1,1) PRIMARY KEY,
    doc_id INT NOT NULL,
    key_id INT NOT NULL,
    val NVARCHAR(255),
    created DATETIME NOT NULL DEFAULT GETDATE(),
    created_by INT NOT NULL DEFAULT 1,
    last_upd DATETIME NOT NULL DEFAULT GETDATE(),
    last_upd_by INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Document_Keywords_Documents FOREIGN KEY (doc_id) REFERENCES Documents(row_id),
    CONSTRAINT FK_Document_Keywords_Keywords FOREIGN KEY (key_id) REFERENCES Keywords(row_id)
);

-- Document_Users table - User access control for documents
CREATE TABLE Document_Users (
    row_id INT IDENTITY(1,1) PRIMARY KEY,
    doc_id INT NOT NULL,
    user_access_id INT NOT NULL,
    owner_flag CHAR(1) DEFAULT 'N',
    access_type NVARCHAR(50) DEFAULT 'READ',
    created DATETIME NOT NULL DEFAULT GETDATE(),
    created_by INT NOT NULL DEFAULT 1,
    last_upd DATETIME NOT NULL DEFAULT GETDATE(),
    last_upd_by INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Document_Users_Documents FOREIGN KEY (doc_id) REFERENCES Documents(row_id),
    CONSTRAINT FK_Document_Users_Users FOREIGN KEY (user_access_id) REFERENCES Users(row_id)
);

-- User_Group_Access table - Group-based access control
CREATE TABLE User_Group_Access (
    row_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    group_id INT,
    access_id INT NOT NULL,
    access_type NVARCHAR(50) DEFAULT 'READ',
    created DATETIME NOT NULL DEFAULT GETDATE(),
    created_by INT NOT NULL DEFAULT 1,
    last_upd DATETIME NOT NULL DEFAULT GETDATE(),
    last_upd_by INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_User_Group_Access_Users FOREIGN KEY (user_id) REFERENCES Users(row_id),
    CONSTRAINT FK_User_Group_Access_Groups FOREIGN KEY (group_id) REFERENCES Groups(row_id)
);

-- User_Sessions table - User session management
CREATE TABLE User_Sessions (
    row_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id NVARCHAR(50) NOT NULL,
    session_key NVARCHAR(255) NOT NULL,
    machine_id NVARCHAR(100),
    created DATETIME NOT NULL DEFAULT GETDATE(),
    expires DATETIME,
    active_flag CHAR(1) DEFAULT 'Y'
);

-- Category_Keywords table - Links categories to keywords
CREATE TABLE Category_Keywords (
    row_id INT IDENTITY(1,1) PRIMARY KEY,
    cat_id INT NOT NULL,
    key_id INT NOT NULL,
    created DATETIME NOT NULL DEFAULT GETDATE(),
    created_by INT NOT NULL DEFAULT 1,
    last_upd DATETIME NOT NULL DEFAULT GETDATE(),
    last_upd_by INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Category_Keywords_Categories FOREIGN KEY (cat_id) REFERENCES Categories(row_id),
    CONSTRAINT FK_Category_Keywords_Keywords FOREIGN KEY (key_id) REFERENCES Keywords(row_id)
);

-- =============================================
-- Indexes for Performance
-- =============================================

-- Documents table indexes
CREATE INDEX IX_Documents_name ON Documents(name);
CREATE INDEX IX_Documents_created ON Documents(created);
CREATE INDEX IX_Documents_last_upd ON Documents(last_upd);
CREATE INDEX IX_Documents_ext_id ON Documents(ext_id);

-- Document_Versions table indexes
CREATE INDEX IX_Document_Versions_doc_id ON Document_Versions(doc_id);
CREATE INDEX IX_Document_Versions_version ON Document_Versions(version);
CREATE INDEX IX_Document_Versions_minio_flg ON Document_Versions(minio_flg);

-- Document_Associations table indexes
CREATE INDEX IX_Document_Associations_doc_id ON Document_Associations(doc_id);
CREATE INDEX IX_Document_Associations_association_id ON Document_Associations(association_id);
CREATE INDEX IX_Document_Associations_fkey ON Document_Associations(fkey);

-- Document_Categories table indexes
CREATE INDEX IX_Document_Categories_doc_id ON Document_Categories(doc_id);
CREATE INDEX IX_Document_Categories_cat_id ON Document_Categories(cat_id);

-- Document_Keywords table indexes
CREATE INDEX IX_Document_Keywords_doc_id ON Document_Keywords(doc_id);
CREATE INDEX IX_Document_Keywords_key_id ON Document_Keywords(key_id);

-- Document_Users table indexes
CREATE INDEX IX_Document_Users_doc_id ON Document_Users(doc_id);
CREATE INDEX IX_Document_Users_user_access_id ON Document_Users(user_access_id);

-- Users table indexes
CREATE INDEX IX_Users_ext_user_id ON Users(ext_user_id);
CREATE INDEX IX_Users_email ON Users(email);

-- User_Sessions table indexes
CREATE INDEX IX_User_Sessions_user_id ON User_Sessions(user_id);
CREATE INDEX IX_User_Sessions_session_key ON User_Sessions(session_key);

-- =============================================
-- Sample Data
-- =============================================

-- Insert default document types
INSERT INTO Document_Types (name, extension, mime_type) VALUES
('PDF Document', 'pdf', 'application/pdf'),
('Word Document', 'doc', 'application/msword'),
('Word Document', 'docx', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'),
('Excel Spreadsheet', 'xls', 'application/vnd.ms-excel'),
('Excel Spreadsheet', 'xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'),
('PowerPoint Presentation', 'ppt', 'application/vnd.ms-powerpoint'),
('PowerPoint Presentation', 'pptx', 'application/vnd.openxmlformats-officedocument.presentationml.presentation'),
('Text File', 'txt', 'text/plain'),
('HTML Document', 'html', 'text/html'),
('Image - JPEG', 'jpg', 'image/jpeg'),
('Image - PNG', 'png', 'image/png'),
('Image - GIF', 'gif', 'image/gif');

-- Insert default associations
INSERT INTO Associations (name, description) VALUES
('Contact', 'Associated with a specific contact'),
('Subscription', 'Associated with a subscription'),
('Domain', 'Associated with a domain'),
('Employee', 'Associated with an employee'),
('Training', 'Associated with training materials');

-- Insert default categories
INSERT INTO Categories (name, description) VALUES
('Training Materials', 'Training and educational content'),
('Certification', 'Certification-related documents'),
('Policies', 'Company policies and procedures'),
('Forms', 'Official forms and templates'),
('Reports', 'Generated reports and analytics'),
('Public', 'Publicly accessible documents'),
('Private', 'Private/internal documents');

-- Insert default keywords
INSERT INTO Keywords (name, description) VALUES
('Important', 'Important documents'),
('Confidential', 'Confidential information'),
('Draft', 'Draft documents'),
('Final', 'Final versions'),
('Archive', 'Archived documents'),
('Review', 'Documents pending review'),
('Approved', 'Approved documents');

-- =============================================
-- Views for Common Queries
-- =============================================

-- View for document details with version information
CREATE VIEW vw_DocumentDetails AS
SELECT 
    d.row_id,
    d.name,
    d.description,
    d.dfilename,
    d.created,
    d.last_upd,
    dt.name AS document_type,
    dt.extension,
    dv.version,
    dv.dsize,
    dv.minio_flg,
    dv.row_id AS version_id
FROM Documents d
LEFT JOIN Document_Types dt ON d.data_type_id = dt.row_id
LEFT JOIN Document_Versions dv ON d.last_version_id = dv.row_id
WHERE d.deleted_flag = 'N';

-- View for document access control
CREATE VIEW vw_DocumentAccess AS
SELECT 
    d.row_id AS doc_id,
    d.name AS document_name,
    u.ext_user_id,
    u.username,
    du.access_type,
    du.owner_flag
FROM Documents d
INNER JOIN Document_Users du ON d.row_id = du.doc_id
INNER JOIN Users u ON du.user_access_id = u.row_id
WHERE d.deleted_flag = 'N' AND u.active_flag = 'Y';

-- =============================================
-- Stored Procedures
-- =============================================

-- Procedure to get document with latest version
CREATE PROCEDURE sp_GetDocumentWithVersion
    @DocumentId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        d.row_id,
        d.name,
        d.description,
        d.dfilename,
        d.created,
        d.last_upd,
        dt.name AS document_type,
        dt.extension,
        dv.version,
        dv.dsize,
        dv.minio_flg,
        dv.row_id AS version_id
    FROM Documents d
    LEFT JOIN Document_Types dt ON d.data_type_id = dt.row_id
    LEFT JOIN Document_Versions dv ON d.last_version_id = dv.row_id
    WHERE d.row_id = @DocumentId AND d.deleted_flag = 'N';
END
GO

-- Procedure to create new document version
CREATE PROCEDURE sp_CreateDocumentVersion
    @DocId INT,
    @DSize BIGINT,
    @MinioFlag CHAR(1) = 'N',
    @CreatedBy INT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @NewVersion INT;
    DECLARE @VersionId INT;
    
    -- Get next version number
    SELECT @NewVersion = ISNULL(MAX(version), 0) + 1 
    FROM Document_Versions 
    WHERE doc_id = @DocId;
    
    -- Insert new version
    INSERT INTO Document_Versions (doc_id, created, created_by, last_upd, last_upd_by, dsize, version, minio_flg)
    VALUES (@DocId, GETDATE(), @CreatedBy, GETDATE(), @CreatedBy, @DSize, @NewVersion, @MinioFlag);
    
    SET @VersionId = SCOPE_IDENTITY();
    
    -- Update document's last_version_id
    UPDATE Documents 
    SET last_version_id = @VersionId, last_upd = GETDATE(), last_upd_by = @CreatedBy
    WHERE row_id = @DocId;
    
    SELECT @VersionId AS version_id, @NewVersion AS version_number;
END
GO

-- =============================================
-- Security and Permissions
-- =============================================

-- Create database roles
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'DMS_Reader')
    CREATE ROLE DMS_Reader;

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'DMS_Writer')
    CREATE ROLE DMS_Writer;

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'DMS_Admin')
    CREATE ROLE DMS_Admin;

-- Grant permissions to roles
GRANT SELECT ON SCHEMA::dbo TO DMS_Reader;
GRANT SELECT, INSERT, UPDATE ON SCHEMA::dbo TO DMS_Writer;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO DMS_Admin;

-- Grant execute permissions on stored procedures
GRANT EXECUTE ON sp_GetDocumentWithVersion TO DMS_Reader, DMS_Writer, DMS_Admin;
GRANT EXECUTE ON sp_CreateDocumentVersion TO DMS_Writer, DMS_Admin;

PRINT 'DMS Database schema created successfully!';
PRINT 'Default data inserted.';
PRINT 'Indexes and views created.';
PRINT 'Stored procedures created.';
PRINT 'Security roles configured.';
