#define T_DIR  1   // Directory
#define T_FILE 2   // File
#define T_DEV  3   // Device

// This is a renamed version of mode_t from fs.h
// Because of dependencies across several files this is
// a much faster and less complicated implemenation than
// if we had used the same union across all files. For all 
// instances mode_t and stat_mode_t the fields, and usage
// are exactly the same.
#ifdef CS333_P4
union stat_mode_t {
    struct {
        uint o_x : 1;  // Other
        uint o_w : 1;
        uint o_r : 1;
        uint g_x : 1;  // Group
        uint g_w : 1;
        uint g_r : 1;
        uint u_x : 1;  // User
        uint u_w : 1;
        uint u_r : 1;
        uint setuid : 1; 
        uint      : 22; // Padding
        } flags;
    uint asInt;
};
#endif

struct stat {
  short type;  // Type of file
  int dev;     // File system's disk device
  uint ino;    // Inode number
  short nlink; // Number of links to file
  uint size;   // Size of file in bytes
  #ifdef CS333_P4
  ushort uid;  // User ID
  ushort gid;  // Group ID
  union stat_mode_t mode;  // Permissions
  #endif
};
