9050 #ifdef CS333_P4
9051 // this is an ugly series of if statements but it works
9052 void
9053 print_mode(struct stat* st)
9054 {
9055   switch (st->type) {
9056     case T_DIR: printf(1, "d"); break;
9057     case T_FILE: printf(1, "-"); break;
9058     case T_DEV: printf(1, "c"); break;
9059     default: printf(1, "?");
9060   }
9061 
9062   if (st->mode.flags.u_r)
9063     printf(1, "r");
9064   else
9065     printf(1, "-");
9066 
9067   if (st->mode.flags.u_w)
9068     printf(1, "w");
9069   else
9070     printf(1, "-");
9071 
9072   if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
9073     printf(1, "S");
9074   else if (st->mode.flags.u_x)
9075     printf(1, "x");
9076   else
9077     printf(1, "-");
9078 
9079   if (st->mode.flags.g_r)
9080     printf(1, "r");
9081   else
9082     printf(1, "-");
9083 
9084   if (st->mode.flags.g_w)
9085     printf(1, "w");
9086   else
9087     printf(1, "-");
9088 
9089   if (st->mode.flags.g_x)
9090     printf(1, "x");
9091   else
9092     printf(1, "-");
9093 
9094   if (st->mode.flags.o_r)
9095     printf(1, "r");
9096   else
9097     printf(1, "-");
9098 
9099 
9100   if (st->mode.flags.o_w)
9101     printf(1, "w");
9102   else
9103     printf(1, "-");
9104 
9105   if (st->mode.flags.o_x)
9106     printf(1, "x");
9107   else
9108     printf(1, "-");
9109 
9110   return;
9111 }
9112 #endif
9113 
9114 
9115 
9116 
9117 
9118 
9119 
9120 
9121 
9122 
9123 
9124 
9125 
9126 
9127 
9128 
9129 
9130 
9131 
9132 
9133 
9134 
9135 
9136 
9137 
9138 
9139 
9140 
9141 
9142 
9143 
9144 
9145 
9146 
9147 
9148 
9149 
