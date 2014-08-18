%{
#include <stdio.h>
#include <string.h>

#ifdef DEBUG
  #define YYERROR_VERBOSE
#endif

/*
void yyerror(const char *str)
{
  fprintf(stderr, "Line %i: %s at %s\n", yylineno, str, yytext);
}
*/

int yywrap()
{
  return 1;
}

int main(void)
{
  yyparse();
  return 0;
}

%}

%union
{
  int number;
  char *string;
}

%token <number> NUMBER;
%token <number> TOKMASK6;
%token <string> TOKACTION;
%token <string> TOKIP;
%token <string> TOKL4;
%token <string> TOKHOST;
%token <string> TOKANY;
%token <string> TOKOPTION;
%token <string> TOKIPADDR;
%token <string> TOKIPADDR6;
%token <string> TOKREM;
%token <string> TOKRANGE;
%token TOKEOL;

%%
commands:
  | commands command TOKEOL
  ;

command:  
  ip_acl
  | l4_acl
  | TOKEOL
  ;

comment:
  TOKREM
  {
    printf("Cool comment dude\n");
  }
  ;

ip_acl:
  TOKACTION TOKIP ip_match
  {
    printf("IP ACL is valid (action %s)\n", $1);
  }
  ;

l4_acl:
  TOKACTION TOKL4 l4_match
  {
    printf("L4 ACL is valid (action %s)\n", $1);
  }
  ;

ip_match:
  TOKANY TOKANY 
  | TOKANY TOKHOST ip_host
  | TOKHOST ip_host TOKANY
  | TOKANY ip_network
  | ip_network TOKANY
  | TOKHOST TOKIPADDR TOKHOST TOKIPADDR
  | TOKHOST TOKIPADDR6 TOKHOST TOKIPADDR6
  | TOKHOST TOKIPADDR TOKIPADDR TOKIPADDR
  | TOKHOST TOKIPADDR6 TOKIPADDR6 TOKMASK6
  | TOKIPADDR TOKIPADDR TOKHOST TOKIPADDR
  | TOKIPADDR6 TOKMASK6 TOKHOST TOKIPADDR6
  | TOKIPADDR TOKIPADDR TOKIPADDR TOKIPADDR
  | TOKIPADDR6 TOKMASK6 TOKIPADDR6 TOKMASK6
  ;

l4_match:
  TOKANY l4_port TOKANY l4_port
  | TOKANY l4_port TOKHOST ip_host l4_port
  | TOKHOST ip_host l4_port TOKANY l4_port
  | TOKANY l4_port ip_network l4_port
  | ip_network l4_port TOKANY l4_port
  | TOKHOST TOKIPADDR l4_port TOKHOST TOKIPADDR l4_port
  | TOKHOST TOKIPADDR6 l4_port TOKHOST TOKIPADDR6 l4_port
  | TOKHOST TOKIPADDR l4_port TOKIPADDR TOKIPADDR l4_port
  | TOKHOST TOKIPADDR6 l4_port TOKIPADDR6 TOKMASK6 l4_port
  | TOKIPADDR TOKIPADDR l4_port TOKHOST TOKIPADDR l4_port
  | TOKIPADDR6 TOKMASK6 l4_port TOKHOST TOKIPADDR6 l4_port
  | TOKIPADDR TOKIPADDR l4_port TOKIPADDR TOKIPADDR l4_port
  | TOKIPADDR6 TOKMASK6 l4_port TOKIPADDR6 TOKMASK6 l4_port
  ;

ip_host:
  TOKIPADDR
  | TOKIPADDR6
  ;

ip_network:
  TOKIPADDR TOKIPADDR
  | TOKIPADDR6 TOKMASK6
  ;

l4_port:
  | TOKOPTION NUMBER
  | TOKRANGE NUMBER NUMBER
  ;
%%

