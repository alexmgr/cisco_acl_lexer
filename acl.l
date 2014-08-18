%{
#include "acl.tab.h"

int lineno = 1;

void yyerror(char *str)
{
  printf("Line %d: %s at %s\n", lineno, str, yytext);
}
%}

%%
 /* Matches port numbers and ACL order numbers*/
[0-9]{1,5}          { yylval.number = atoi(yytext); return NUMBER; }
 /* Actions allowed on the traffic */
permit|deny         { yylval.string = strdup(yytext); return TOKACTION; }
remark              { yylval.string = strdup(yytext); return TOKREM; }
 /* Make the allowed protocol the selector */
ip                  { yylval.string = strdup(yytext); return TOKIP; }
tcp|udp             { yylval.string = strdup(yytext); return TOKL4; }
 /* Allowed special matching keywords */
host                { yylval.string = strdup(yytext); return TOKHOST; }
any                 { yylval.string = strdup(yytext); return TOKANY; }
 /* Options ending the ACL. Context dependent */
eq|neq|gt|lt        { yylval.string = strdup(yytext); return TOKOPTION; }
range               { yylval.string = strdup(yytext); return TOKRANGE; }
 /* Match for ipv4 addresses, netmasks and wildcard masks*/
(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)  { yylval.string = strdup(yytext); return TOKIPADDR; }
 /* Match for ipv6 addresses */
\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?\s* { yylval.string = strdup(yytext); return TOKIPADDR6; }
\/[0-9]{1,3}         { char *s = strdup(yytext);
                       yylval.number = atoi(memmove(s, s+1, strlen(s)));
                       return TOKMASK6; 
                     }
 /* EOL separator. Will be used to end an ACL entry */
 \n                 {
                      ++lineno;
                      return TOKEOL;
                    }
%%

