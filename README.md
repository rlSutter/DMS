# DMS (Document Management System) Services

A comprehensive document management system built with ASP.NET Web Services that integrates with MinIO object storage and SQL Server databases for metadata management.

## Overview

The DMS Services system provides a full-featured document management solution with the following key capabilities:

- **Document Storage**: Binary document storage using MinIO object storage
- **Metadata Management**: SQL Server database for document metadata, versions, and relationships
- **Access Control**: Role-based and user-based access control
- **Version Control**: Document versioning with history tracking
- **Categorization**: Document categorization and keyword tagging
- **Associations**: Link documents to external entities (contacts, subscriptions, etc.)
- **Web Services API**: RESTful web services for document operations
- **User Management**: Session management and user authentication

## Architecture

### Technology Stack

- **Backend**: ASP.NET Web Services (VB.NET)
- **Database**: SQL Server (metadata storage)
- **Object Storage**: MinIO (binary document storage)
- **Logging**: log4net
- **Caching**: Local caching wrapper
- **Authentication**: Windows Authentication

### System Components

1. **Service.asmx** - Main web service providing document management operations
2. **GetContent.ashx** - Content retrieval handler
3. **GetContentBE.ashx** - Backend content retrieval with advanced filtering
4. **OpenDocument.ashx** - Document opening and streaming handler
5. **Database Schema** - SQL Server database with comprehensive metadata tables

## Database Schema

The system uses a comprehensive SQL Server database schema with the following main tables:

### Core Tables

- **Documents** - Main document metadata
- **Document_Versions** - Version control for documents
- **Document_Types** - File type definitions
- **Users** - System users
- **Groups** - User groups for access control

### Relationship Tables

- **Document_Associations** - Links documents to external entities
- **Document_Categories** - Document categorization
- **Document_Keywords** - Document tagging
- **Document_Users** - User access control
- **User_Group_Access** - Group-based access control

### Supporting Tables

- **Associations** - Association type definitions
- **Categories** - Category definitions
- **Keywords** - Keyword definitions
- **User_Sessions** - Session management

## Installation and Setup

### Prerequisites

- Windows Server with IIS
- SQL Server 2016 or later
- MinIO server instance
- .NET Framework 4.7.2 or later

### Database Setup

1. Run the provided `DMS_Database_Schema.sql` script to create the database schema
2. Configure connection strings in `web.config`
3. Set up database users and permissions

### MinIO Configuration

1. Install and configure MinIO server
2. Create buckets for document storage
3. Configure access keys and secrets in `web.config`

### Web Application Setup

1. Deploy the web application to IIS
2. Configure application pool with appropriate permissions
3. Update `web.config` with environment-specific settings
4. Set up logging directories and permissions

## Configuration

### Web.config Settings

```xml
<appSettings>
    <!-- Database Configuration -->
    <add key="dbuser" value="your_db_user" />
    <add key="dbpass" value="your_db_password" />
    
    <!-- MinIO Configuration -->
    <add key="minio-key" value="your_minio_access_key" />
    <add key="minio-secret" value="your_minio_secret_key" />
    <add key="minio-region" value="your_region" />
    <add key="minio-bucket" value="your_bucket_name" />
    
    <!-- System Configuration -->
    <add key="basepath" value="C:\Inetpub\dms\" />
    
    <!-- Debug Settings -->
    <add key="SaveDMSDocDoc_debug" value="N" />
    <add key="GetDocument_debug" value="Y" />
    <!-- ... other debug settings ... -->
</appSettings>

<connectionStrings>
    <add name="dms" connectionString="server=your_server;database=DMS;Min Pool Size=3;Max Pool Size=5;Connect Timeout=10" providerName="System.Data.SqlClient" />
    <add name="siebeldb" connectionString="server=your_server;database=siebeldb;Min Pool Size=3;Max Pool Size=5" providerName="System.Data.SqlClient" />
    <add name="hcidb" connectionString="server=your_server;Min Pool Size=3;Max Pool Size=5;Connect Timeout=10;database=your_database" providerName="System.Data.SqlClient" />
</connectionStrings>
```

## API Reference

### Main Web Service Methods

#### Document Management

- **SaveDMSDoc** - Save or update a document
- **UpdateDoc** - Update an existing document
- **GetDocument** - Retrieve document information
- **DelDocument** - Delete a document
- **PublishDMSDoc** - Publish document to users

#### Document Associations

- **SaveDMSDocAssoc** - Create document associations
- **SaveDMSDocCat** - Assign document categories
- **SaveDMSDocKey** - Assign document keywords
- **SaveDMSDocUser** - Set document user access

#### User Management

- **UserLogin** - User authentication
- **UserLogout** - User session termination
- **CheckDocAccess** - Verify document access rights

#### Utility Functions

- **VerifyDocument** - Document verification
- **UpdDMSDocCount** - Update document counts
- **EmpQuery** - Employee query operations

### Handler Endpoints

- **GetContent.ashx** - Content retrieval with filtering
- **GetContentBE.ashx** - Advanced content retrieval
- **OpenDocument.ashx** - Document streaming and opening

## Usage Examples

### Saving a Document

```vb
Dim service As New Service()
Dim result As String = service.SaveDMSDoc(
    DocId:="", 
    ItemName:="Sample Document", 
    DFileName:="sample.pdf",
    DImage:="base64_encoded_content",
    DSize:="1024",
    UserId:="user123",
    Debug:="N"
)
```

### Retrieving Documents

```vb
Dim service As New Service()
Dim result As String = service.GetDocument(
    DocId:="123",
    UserId:="user123",
    Debug:="N"
)
```

### Creating Document Associations

```vb
Dim service As New Service()
Dim result As String = service.SaveDMSDocAssoc(
    DocId:="123",
    Association:="Contact",
    AssocKey:="contact456",
    PrFlag:="Y",
    ReqdFlag:="N",
    Rights:="READ",
    Debug:="N"
)
```

## Security Features

### Access Control

- **User-based Access**: Individual user permissions for documents
- **Group-based Access**: Role-based access control through groups
- **Document-level Security**: Per-document access control
- **Session Management**: Secure session handling with expiration

### Data Protection

- **Binary Storage**: Documents stored securely in MinIO
- **Metadata Encryption**: Sensitive metadata protection
- **Audit Logging**: Comprehensive logging of all operations
- **Input Validation**: SQL injection and XSS protection

## Logging and Monitoring

### Logging Configuration

The system uses log4net for comprehensive logging:

- **Event Logging**: System events and errors
- **Debug Logging**: Detailed operation tracing
- **Performance Logging**: Operation timing and metrics
- **File-based Logging**: Rotating log files with size limits

### Log Categories

- **EventLog**: System events and errors
- **PDDDebugLog**: Document operations debugging
- **AUDDCDebugLog**: Audit operations
- **UDDCDebugLog**: User operations
- **SDDADebugLog**: System operations

## Performance Considerations

### Caching

- **Local Caching**: In-memory caching for frequently accessed data
- **Database Connection Pooling**: Optimized connection management
- **Query Optimization**: Indexed database queries

### Scalability

- **MinIO Integration**: Scalable object storage
- **Database Optimization**: Proper indexing and query optimization
- **Load Balancing**: Support for multiple application instances

## Troubleshooting

### Common Issues

1. **Database Connection Errors**
   - Verify connection strings in web.config
   - Check database server availability
   - Validate user permissions

2. **MinIO Connection Issues**
   - Verify MinIO server configuration
   - Check access keys and secrets
   - Validate network connectivity

3. **Document Upload Failures**
   - Check file size limits
   - Verify MinIO bucket permissions
   - Review error logs for specific issues

### Debug Mode

Enable debug mode by setting debug flags to "Y" in web.config:

```xml
<add key="SaveDMSDocDoc_debug" value="Y" />
<add key="GetDocument_debug" value="Y" />
```

## Development and Customization

### Adding New Document Types

1. Insert new record in `Document_Types` table
2. Update MIME type handling in `OpenDocument.ashx`
3. Test document upload and retrieval

### Custom Associations

1. Add new association type to `Associations` table
2. Update association handling in service methods
3. Modify UI components as needed

### Extending Access Control

1. Add new user groups to `Groups` table
2. Update access control logic in service methods
3. Modify permission checking functions

## File Structure

```
DMS_Services/
├── App_Code/
│   └── Service.vb                 # Main service implementation
├── Bin/                          # Compiled assemblies
├── images/                       # UI images and icons
├── js/                          # JavaScript files
├── packages/                    # NuGet packages
├── work_dir/                    # Temporary working directory
├── Service.asmx                 # Web service definition
├── GetContent.ashx              # Content retrieval handler
├── GetContentBE.ashx            # Backend content handler
├── OpenDocument.ashx            # Document opening handler
├── web.config                   # Application configuration
├── packages.config              # Package dependencies
└── README.md                    # This documentation
```

## Dependencies

### NuGet Packages

- **AWSSDK.S3** (3.7.1.3) - MinIO/S3 integration
- **AWSSDK.Core** (3.7.0.33) - AWS SDK core
- **log4net** (2.0.12) - Logging framework
- **Newtonsoft.Json** (13.0.1) - JSON serialization
- **RestSharp** (106.11.7) - HTTP client
- **System.Reactive** (5.0.0) - Reactive extensions

### System Requirements

- **.NET Framework**: 4.7.2 or later
- **IIS**: 8.0 or later
- **SQL Server**: 2016 or later
- **Windows Server**: 2012 R2 or later

## License and Support

This document management system is designed for enterprise use with comprehensive security and scalability features. For support and customization requests, please contact the development team.

## Version History

- **v1.0** - Initial release with core document management features
- **v1.1** - Added MinIO integration and enhanced security
- **v1.2** - Improved performance and caching
- **v1.3** - Enhanced user management and access control

---

*Last Updated: [Current Date]*
*Version: 1.3*
