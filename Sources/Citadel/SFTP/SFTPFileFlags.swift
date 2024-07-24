import Foundation

// pflags
public struct SFTPOpenFileFlags: OptionSet, CustomDebugStringConvertible {
    public var rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    /// SSH_FXF_READ
    ///
    /// Open the file for reading.
    public static let read = SFTPOpenFileFlags(rawValue: 0x00000001)
    
    /// SSH_FXF_WRITE
    ///
    /// Open the file for writing.  If both this and SSH_FXF_READ are
    /// specified, the file is opened for both reading and writing.
    public static let write = SFTPOpenFileFlags(rawValue: 0x00000002)
    
    /// SSH_FXF_APPEND
    ///
    /// Force all writes to append data at the end of the file.
    public static let append = SFTPOpenFileFlags(rawValue: 0x00000004)
    
    /// SSH_FXF_CREAT
    ///
    /// If this flag is specified, then a new file will be created if one
    /// does not already exist (if O_TRUNC is specified, the new file will
    /// be truncated to zero length if it previously exists).
    public static let create = SFTPOpenFileFlags(rawValue: 0x00000008)
    
    /// SSH_FXF_TRUNC
    ///
    /// Forces an existing file with the same name to be truncated to zero
    /// length when creating a file by specifying SSH_FXF_CREAT.
    /// SSH_FXF_CREAT MUST also be specified if this flag is used.
    public static let truncate = SFTPOpenFileFlags(rawValue: 0x00000010)
    
    /// SSH_FXF_EXCL
    ///
    /// Causes the request to fail if the named file already exists.
    /// SSH_FXF_CREAT MUST also be specified if this flag is used.
    public static let forceCreate = SFTPOpenFileFlags(rawValue: 0x00000020)
    
    public var debugDescription: String {
        String(format: "0x%08x", self.rawValue)
    }
}

public struct SFTPFileAttributes: CustomDebugStringConvertible {
    public struct Flags: OptionSet {
        public var rawValue: UInt32
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
        
        public static let size = Flags(rawValue: 0x00000001)
        public static let uidgid = Flags(rawValue: 0x00000002)
        public static let permissions = Flags(rawValue: 0x00000004)
        public static let acmodtime = Flags(rawValue: 0x00000008)
        public static let extended = Flags(rawValue: 0x80000000)
    }
    
    public struct Permissions: OptionSet {
        public var rawValue: UInt32
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
        
        // Permission bits. These correspond to the POSIX bit masks defined in sys/stat.h
        // Values were copied from the FreeBSD source code (BSD license): https://github.com/freebsd/freebsd-src/blob/bb7f7d5b5201cfe569fce79b0f325bec2cf38ad2/sys/sys/stat.h
        
        //#define	S_IFMT	 0170000		/* type of file mask */
        public static let fileTypeMask = Permissions(rawValue: 0o170000)
        //#define	S_IFIFO	 0010000		/* named pipe (fifo) */
        public static let isFifo = Permissions(rawValue: 0o10000)
        //#define	S_IFCHR	 0020000		/* character special */
        public static let isCharacterSpecial = Permissions(rawValue: 0o20000)
        //#define	S_IFDIR	 0040000		/* directory */
        public static let isDirectory = Permissions(rawValue: 0o40000)
        //#define	S_IFBLK	 0060000		/* block special */
        public static let isBlockSpecial = Permissions(rawValue: 0o60000)
        //#define	S_IFREG	 0100000		/* regular */
        public static let isRegularFile = Permissions(rawValue: 0o100000)
        //#define	S_IFLNK	 0120000		/* symbolic link */
        public static let isSymbolicLink = Permissions(rawValue: 0o120000)
        //#define	S_IFSOCK 0140000		/* socket */
        public static let isSocket = Permissions(rawValue: 0o140000)
        //#define	S_ISVTX	 0001000		/* save swapped text even after use */
        public static let isSticky = Permissions(rawValue: 0o1000)
        
        //#define	S_ISUID	0004000			/* set user id on execution */
        public static let setUserId = Permissions(rawValue: 0o4000)
        //#define	S_ISGID	0002000			/* set group id on execution */
        public static let setGroupId = Permissions(rawValue: 0o2000)
        
        //#define	S_IRWXU	0000700			/* RWX mask for owner */
        public static let ownerMask = Permissions(rawValue: 0o700)
        //#define	S_IRUSR	0000400			/* R for owner */
        public static let ownerRead = Permissions(rawValue: 0o400)
        //#define	S_IWUSR	0000200			/* W for owner */
        public static let ownerWrite = Permissions(rawValue: 0o200)
        //#define	S_IXUSR	0000100			/* X for owner */
        public static let ownerExecute = Permissions(rawValue: 0o100)
        
        //#define	S_IRWXG	0000070			/* RWX mask for group */
        public static let groupMask = Permissions(rawValue: 0o70)
        //#define	S_IRGRP	0000040			/* R for group */
        public static let groupRead = Permissions(rawValue: 0o40)
        //#define	S_IWGRP	0000020			/* W for group */
        public static let groupWrite = Permissions(rawValue: 0o20)
        //#define	S_IXGRP	0000010			/* X for group */
        public static let groupExecute = Permissions(rawValue: 0o10)
        
        //#define	S_IRWXO	0000007			/* RWX mask for other */
        public static let otherMask = Permissions(rawValue: 0o7)
        //#define	S_IROTH	0000004			/* R for other */
        public static let otherRead = Permissions(rawValue: 0o4)
        //#define	S_IWOTH	0000002			/* W for other */
        public static let otherWrite = Permissions(rawValue: 0o2)
        //#define	S_IXOTH	0000001			/* X for other */
        public static let otherExecute = Permissions(rawValue: 0o1)
    }
    
    public struct UserGroupId {
        public let userId: UInt32
        public let groupId: UInt32
        
        public init(
            userId: UInt32,
            groupId: UInt32
        ) {
            self.userId = userId
            self.groupId = groupId
        }
    }
    
    public struct AccessModificationTime {
        // Both written as UInt32 seconds since jan 1 1970 as UTC
        public let accessTime: Date
        public let modificationTime: Date
        
        public init(
            accessTime: Date,
            modificationTime: Date
        ) {
            self.accessTime = accessTime
            self.modificationTime = modificationTime
        }
    }
    
    public var flags: Flags {
        var flags: Flags = []
        
        if size != nil {
            flags.insert(.size)
        }
        
        if uidgid != nil {
            flags.insert(.uidgid)
        }
        
        if permissions != nil {
            flags.insert(.permissions)
        }
        
        if accessModificationTime != nil {
            flags.insert(.acmodtime)
        }
        
        if !extended.isEmpty {
            flags.insert(.extended)
        }
        
        return flags
    }
    
    public var size: UInt64?
    public var uidgid: UserGroupId?
    
    public var permissions: Permissions?
    public var accessModificationTime: AccessModificationTime?
    public var extended = [(String, String)]()
    
    public init(size: UInt64? = nil, accessModificationTime: AccessModificationTime? = nil) {
        self.size = size
        self.accessModificationTime = accessModificationTime
    }
    
    public static let none = SFTPFileAttributes()
    public static let all: SFTPFileAttributes = {
        var attr = SFTPFileAttributes()
//        attr.permissions = 777
        return attr
    }()
    
    public var debugDescription: String { "{perm: \(permissions), size: \(size), uidgid: \(uidgid)}" }
}
