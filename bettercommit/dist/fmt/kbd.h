7400 // PC keyboard interface constants
7401 
7402 #define KBSTATP         0x64    // kbd controller status port(I)
7403 #define KBS_DIB         0x01    // kbd data in buffer
7404 #define KBDATAP         0x60    // kbd data port(I)
7405 
7406 #define NO              0
7407 
7408 #define SHIFT           (1<<0)
7409 #define CTL             (1<<1)
7410 #define ALT             (1<<2)
7411 
7412 #define CAPSLOCK        (1<<3)
7413 #define NUMLOCK         (1<<4)
7414 #define SCROLLLOCK      (1<<5)
7415 
7416 #define E0ESC           (1<<6)
7417 
7418 // Special keycodes
7419 #define KEY_HOME        0xE0
7420 #define KEY_END         0xE1
7421 #define KEY_UP          0xE2
7422 #define KEY_DN          0xE3
7423 #define KEY_LF          0xE4
7424 #define KEY_RT          0xE5
7425 #define KEY_PGUP        0xE6
7426 #define KEY_PGDN        0xE7
7427 #define KEY_INS         0xE8
7428 #define KEY_DEL         0xE9
7429 
7430 // C('A') == Control-A
7431 #define C(x) (x - '@')
7432 
7433 static uchar shiftcode[256] =
7434 {
7435   [0x1D] CTL,
7436   [0x2A] SHIFT,
7437   [0x36] SHIFT,
7438   [0x38] ALT,
7439   [0x9D] CTL,
7440   [0xB8] ALT
7441 };
7442 
7443 static uchar togglecode[256] =
7444 {
7445   [0x3A] CAPSLOCK,
7446   [0x45] NUMLOCK,
7447   [0x46] SCROLLLOCK
7448 };
7449 
7450 static uchar normalmap[256] =
7451 {
7452   NO,   0x1B, '1',  '2',  '3',  '4',  '5',  '6',  // 0x00
7453   '7',  '8',  '9',  '0',  '-',  '=',  '\b', '\t',
7454   'q',  'w',  'e',  'r',  't',  'y',  'u',  'i',  // 0x10
7455   'o',  'p',  '[',  ']',  '\n', NO,   'a',  's',
7456   'd',  'f',  'g',  'h',  'j',  'k',  'l',  ';',  // 0x20
7457   '\'', '`',  NO,   '\\', 'z',  'x',  'c',  'v',
7458   'b',  'n',  'm',  ',',  '.',  '/',  NO,   '*',  // 0x30
7459   NO,   ' ',  NO,   NO,   NO,   NO,   NO,   NO,
7460   NO,   NO,   NO,   NO,   NO,   NO,   NO,   '7',  // 0x40
7461   '8',  '9',  '-',  '4',  '5',  '6',  '+',  '1',
7462   '2',  '3',  '0',  '.',  NO,   NO,   NO,   NO,   // 0x50
7463   [0x9C] '\n',      // KP_Enter
7464   [0xB5] '/',       // KP_Div
7465   [0xC8] KEY_UP,    [0xD0] KEY_DN,
7466   [0xC9] KEY_PGUP,  [0xD1] KEY_PGDN,
7467   [0xCB] KEY_LF,    [0xCD] KEY_RT,
7468   [0x97] KEY_HOME,  [0xCF] KEY_END,
7469   [0xD2] KEY_INS,   [0xD3] KEY_DEL
7470 };
7471 
7472 static uchar shiftmap[256] =
7473 {
7474   NO,   033,  '!',  '@',  '#',  '$',  '%',  '^',  // 0x00
7475   '&',  '*',  '(',  ')',  '_',  '+',  '\b', '\t',
7476   'Q',  'W',  'E',  'R',  'T',  'Y',  'U',  'I',  // 0x10
7477   'O',  'P',  '{',  '}',  '\n', NO,   'A',  'S',
7478   'D',  'F',  'G',  'H',  'J',  'K',  'L',  ':',  // 0x20
7479   '"',  '~',  NO,   '|',  'Z',  'X',  'C',  'V',
7480   'B',  'N',  'M',  '<',  '>',  '?',  NO,   '*',  // 0x30
7481   NO,   ' ',  NO,   NO,   NO,   NO,   NO,   NO,
7482   NO,   NO,   NO,   NO,   NO,   NO,   NO,   '7',  // 0x40
7483   '8',  '9',  '-',  '4',  '5',  '6',  '+',  '1',
7484   '2',  '3',  '0',  '.',  NO,   NO,   NO,   NO,   // 0x50
7485   [0x9C] '\n',      // KP_Enter
7486   [0xB5] '/',       // KP_Div
7487   [0xC8] KEY_UP,    [0xD0] KEY_DN,
7488   [0xC9] KEY_PGUP,  [0xD1] KEY_PGDN,
7489   [0xCB] KEY_LF,    [0xCD] KEY_RT,
7490   [0x97] KEY_HOME,  [0xCF] KEY_END,
7491   [0xD2] KEY_INS,   [0xD3] KEY_DEL
7492 };
7493 
7494 
7495 
7496 
7497 
7498 
7499 
7500 static uchar ctlmap[256] =
7501 {
7502   NO,      NO,      NO,      NO,      NO,      NO,      NO,      NO,
7503   NO,      NO,      NO,      NO,      NO,      NO,      NO,      NO,
7504   C('Q'),  C('W'),  C('E'),  C('R'),  C('T'),  C('Y'),  C('U'),  C('I'),
7505   C('O'),  C('P'),  NO,      NO,      '\r',    NO,      C('A'),  C('S'),
7506   C('D'),  C('F'),  C('G'),  C('H'),  C('J'),  C('K'),  C('L'),  NO,
7507   NO,      NO,      NO,      C('\\'), C('Z'),  C('X'),  C('C'),  C('V'),
7508   C('B'),  C('N'),  C('M'),  NO,      NO,      C('/'),  NO,      NO,
7509   [0x9C] '\r',      // KP_Enter
7510   [0xB5] C('/'),    // KP_Div
7511   [0xC8] KEY_UP,    [0xD0] KEY_DN,
7512   [0xC9] KEY_PGUP,  [0xD1] KEY_PGDN,
7513   [0xCB] KEY_LF,    [0xCD] KEY_RT,
7514   [0x97] KEY_HOME,  [0xCF] KEY_END,
7515   [0xD2] KEY_INS,   [0xD3] KEY_DEL
7516 };
7517 
7518 
7519 
7520 
7521 
7522 
7523 
7524 
7525 
7526 
7527 
7528 
7529 
7530 
7531 
7532 
7533 
7534 
7535 
7536 
7537 
7538 
7539 
7540 
7541 
7542 
7543 
7544 
7545 
7546 
7547 
7548 
7549 
