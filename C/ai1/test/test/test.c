#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


#if 1

void convert(char*, char*);
void push(char*, char);
char pop(char*);
int is_empty(char*);
char check_top(char*);

int main() {

	char input[100] = {'\0',};
	char calStack[100] = { '\0', };
	char convStack[100] = { '\0', };

	printf("수식 입력: ");
	fgets(input, 100, stdin);

	convert(input, convStack);

	printf("%s", convStack);
	
	return 0;
}

void convert(char* pIn, char* pConv) {

	char opStack[100] = { '\0', };
	char* pOp = opStack;
	char temp;
	
	while (*pIn) {
		printf("isempty: %d / actual: %s\n", is_empty(pOp), pOp);
		
		if (*pIn >= '1' && *pIn <= '9') {
			push(pConv, *pIn);
		}
		else if (*pIn == '+' || *pIn == '-') {
			while (1) {
				if (!is_empty && check_top(pOp) != '(') {
					push(pConv, pop(pOp));
				}
				else {
					push(pOp, *pIn);
					break;
				}
			}
		}
		else if (*pIn == '*' || *pIn == '/') {
			while (1) {
				if (!is_empty && check_top(pOp) != '(' 
					&& check_top(pOp) != '+' && check_top(pOp) != '-') {
					push(pConv, pop(pOp));
				}
				else {
					push(pOp, *pIn);
					break;
				}
			}
		}
		else if(*pIn == ')') {
			while (1) {
				temp = pop(pOp);
				if (temp == '(') break;
				push(pOp, temp);
			}
		}
		pIn++; 
	}
	while (!is_empty(pOp)) {
		printf("1");
		push(pConv, pop(pOp));
		
	}

	printf("pOp: %s\n", pOp);
}

void push(char* p, char c) {
	*(p + strlen(p)) = c;
}
char pop(char* p) {
	char temp;

	
	temp = *(p + strlen(p));
	printf("pop: %c\n", temp);
	*(p + strlen(p)) = '\0';

	return temp;
}
int is_empty(char* p){
	return (strlen(p) ? 0 : 1);
}
char check_top(char* p) {
	return *(p + strlen(p));
}

#endif


//파일입출력 + 구조체
#if 0
/*
   구조체를 화일처리(화일 포인터. fseek, rewind)로 구조 변경
   --> 프로그램을 종료 하더라도 이전 정보가 그대로 남아 있도록 하기 위함
   --> 마치 DB
*/
#define _CRT_SECURE_NO_WARNINGS
/*
#include <stdio.h>
#include <string.h>
#include <stdlib.h>    // atoi itoa malloc등이 들어 있다. 
*/
#define NAME_LEN   20

void show_menu(void);       // 메뉴출력
void make_account(void);       // 계좌개설을 위한 함수
void deposit_money(void);       // 입    금
void with_draw_money(void);      // 출    금
void show_all_acc_info(void);     // 잔액조회

enum { MAKE = 1, DEPOSIT, WITHDRAW, INQUIRE, EXIT = 9 };

// #define : 매크로 (MACRO)
#define MAKE     1
#define DEPOSIT  2
#define WITHDRAW 3
#define INQUIRE  4
#define EXIT     9


typedef struct
{
	int acc_id;      // 계좌번호
	int balance;    // 잔    액
	char cus_name[NAME_LEN];   // 고객이름
} t_account;
/*
struct
{
	int acc_id;     // 계좌번호
	int balance;    // 잔    액
	char cus_name[NAME_LEN];   // 고객이름
} account;

struct account acc_arr[100];
*/
void make_account(t_account* pt, int* pn);   // 계좌개설
void deposit_money(t_account* pt, int* pn);  // 입금
void with_draw_money(t_account* pt, int* pn);  // 출금 
void show_all_acc_info(t_account* pt, int* pn); // 잔액조회

FILE* filep;    // money_file

int main()  // int main(argc, char *argv[])
{
	int choice;
#if 0
	t_account* acc_arr;   // acc_arr라는 변수는 t_account 타입의 구조체 타입의 
	// 포인터(주소를 저장하는 공간(변수) 이다. 
	void (*fp[]) (t_account*, int*) =
	{
		NULL, // 0
		make_account,
		deposit_money,
		with_draw_money,
		show_all_acc_info
	};


	acc_arr = (t_account*)malloc(sizeof(t_account) * 10);   // acc_arr[10];
	// malloc의 리턴 되는 default는 char *이나 이를 구조체 포인터로 변환
	// acc_arr에는 시작 번지가 리턴 된다. 
	if (acc_arr == NULL)
	{
		printf("메모리 할당 실패 @!!!!!\n");
		return -1;   // 0: 정상종료 -1: 심각한 error
	}

#else  // orginal 
	void (*fp[]) (t_account*, int*) =
	{
		NULL, // 0
		make_account,
		deposit_money,
		with_draw_money,
		show_all_acc_info
	};
	t_account acc_arr[10];   // Account 저장을 위한 배열
#endif 

	int acc_num = 0;        // 저장된 Account 수

	if ((filep = fopen("money_file", "rb+")) == NULL)
	{
		if ((filep = fopen("money_file", "wb+")) == NULL)
		{
			fprintf(stderr, "can't open money_file !!!\n");
			exit(1); // 실행 종료 error code 1
		}
	}
	while (1)
	{
		show_menu();
		printf("선택: ");
		scanf("%d", &choice);  // '1' --> 1 --> choice
		printf("\n");
		if (choice == 9)
		{
			// free(acc_arr);
			fclose(filep);   // 화일의 연결을 끊는다 
			break;
		}
		if (choice >= 1 && choice <= 4)
			fp[choice](acc_arr, &acc_num);

#if 0  // 함수 포인터 배열로 동작 되도록 완성 하시오 
		switch (choice)
		{
		case MAKE:  // 	case 1:
			make_account(acc_arr, &acc_num);
			break;
		case DEPOSIT:
			deposit_money(acc_arr, &acc_num);
			break;
		case WITHDRAW:
			with_draw_money(acc_arr, &acc_num);
			break;
		case INQUIRE:   // case 4:
			show_all_acc_info(acc_arr, &acc_num);
			break;
		case EXIT:
			free(acc_arr);   // 동적 메모리를 해제 한다. 
			return 0;
		default:
			printf("Illegal selection..\n");
		}
#endif 
	}
	return 0;
}

void show_menu(void)
{
	char* menu[] =   //  
	{
	 "-----Menu------\n",
	 "1. 계좌개설\n",
	 "2. 입    금\n",
	 "3. 출    금\n",
	 "4. 계좌정보 전체 출력\n",
	 "9. 종    료\n"
	};

	int i;

	for (i = 0; i < 6; i++)
		printf("%s", *(menu + i));   // printf("%s", menu[i]);
}

void make_account(t_account* pt, int* pn)
{
	int id;
	char name[NAME_LEN];
	int balance;
	t_account* p = pt + *pn;

	printf("[계좌개설]\n");
	printf("계좌ID: ");
	scanf("%d", &id);
	printf("이  름: ");
	scanf("%s", name);
	printf("입금액: ");
	scanf("%d", &balance);
	printf("\n");

	rewind(filep);   // 화일의 헤더를 처음으로 위치

	for (int i = 0; ; i++)
	{
		if (fread((char*)&p->acc_id, 1, sizeof(t_account), filep) == NULL)
		{
			break;   // 더이상 읽을 데이타가 없을때 
		}
		else if (p->acc_id == id)
		{
			printf("Already exist ID : %d\n", id);
			return;
		}
	}
	fseek(filep, 0, SEEK_END);  // 헤더를 화일의 맨끝으로 이동 
	p->acc_id = id;   // (*p).acc_id = id;
	p->balance = balance;
	strcpy(p->cus_name, name);
	fwrite((char*)&p->acc_id, 1, sizeof(t_account), filep);
	*pn += 1;  // pn +=1   주소가 증가 되는것이다. 
}

void deposit_money(t_account* pt, int* pn)
{
	int money;
	int id, i, size;
	t_account* p = pt;

	printf("[입    금]\n");
	printf("계좌ID: ");
	scanf("%d", &id);
	printf("입금액: ");
	scanf("%d", &money);

	rewind(filep);
	// for (i = 0; i < *pn; i++, p++)
	for (i = 0; ; i++, p++)
	{
		if (fread((char*)&p->acc_id, 1, sizeof(t_account), filep) == NULL)
		{
			break;   // 더이상 읽을 데이타가 없을때 
		}
		else if (p->acc_id == id)
		{
			p->balance += money;
			size = sizeof(t_account);
			fseek(filep, -size, SEEK_CUR); // 현재 헤더에서 -28byte만큼 헤더를 뒤로 옮김다.
			fwrite((char*)&p->acc_id, 1, sizeof(t_account), filep);
			printf("입금완료\n\n");
			return;
		}
	}
	printf("유효하지 않은 ID 입니다.\n\n");
}

void with_draw_money(t_account* pt, int* pn)
{
	int money;
	int id, i, size;
	t_account* p = pt;

	printf("[출    금]\n");
	printf("계좌ID: ");
	scanf("%d", &id);
	printf("출금액: ");
	scanf("%d", &money);

	rewind(filep);
	// for (i = 0; i < *pn; i++, p++)
	for (i = 0; ; i++, p++)
	{
		if (fread((char*)&p->acc_id, 1, sizeof(t_account), filep) == NULL)
		{
			break;   // 더이상 읽을 데이타가 없을때 
		}
		else if (p->acc_id == id)
		{
			if (p->balance < money)
			{
				printf("잔액부족\n\n");
				return;
			}

			p->balance -= money;  // acc_arr[i].balance = acc_arr[i].balance - money;
			size = sizeof(t_account);
			fseek(filep, -size, SEEK_CUR); // 현재 헤더에서 -28byte만큼 헤더를 뒤로 옮김다.
			fwrite((char*)&p->acc_id, 1, sizeof(t_account), filep);
			printf("출금완료\n\n");
			return;
		}
	}
	printf("유효하지 않은 ID 입니다.\n\n");
}

void show_all_acc_info(t_account* pt, int* pn)
{
	int i;
	t_account* p = pt;

	rewind(filep);   // 화일의 헤더를 맨 처음으로 이동
	//for (i = 0; i < *pn; i++, p++)
	for (i = 0; ; i++, p++)
	{
		if (fread((char*)&p->acc_id, 1, sizeof(t_account), filep) == NULL)
		{
			break;   // 더이상 읽을 데이타가 없을때 
		}
		printf("계좌ID: %d\n", p->acc_id);
		printf("이  름: %s\n", p->cus_name);
		printf("잔  액: %d\n\n", p->balance);
	}
	printf("\n");
}
#endif


// 구조체 활용
#if 0
#define NAME_LEN   20


typedef struct
{
	int acc_id;      // 계좌번호
	int balance;    // 잔    액
	char cus_name[NAME_LEN];   // 고객이름
} t_account; // t_ -> typedef prefix

void show_menu(void);       // 메뉴출력
void make_account(t_account* pt, int* pn);       // 계좌개설을 위한 함수
void deposit_money(t_account* pt, int* pn);       // 입    금
void with_draw_money(t_account* pt, int* pn);      // 출    금
void show_all_acc_info(t_account* pt, int* pn);     // 잔액조회

enum { MAKE = 1, DEPOSIT, WITHDRAW, INQUIRE, EXIT = 9 };

t_account acc_arr[100];   // Account 저장을 위한 배열
int acc_num = 0;        // 저장된 Account 수

int main()  // int main(argc, char *argv[])
{
	//printf("size=%d\n", sizeof(acc_arr[1]));
	int choice;

	while (1)
	{
		show_menu();
		printf("선택: ");
		(void)scanf("%d", &choice);
		printf("\n");

		switch (choice)
		{
		case MAKE:
			make_account(&acc_arr, &acc_num);
			break;
		case DEPOSIT:
			deposit_money(&acc_arr, &acc_num);
			break;
		case WITHDRAW:
			with_draw_money(&acc_arr, &acc_num);
			break;
		case INQUIRE:
			show_all_acc_info(&acc_arr, &acc_num);
			break;
		case EXIT:
			return 0;
		default:
			printf("Illegal selection..\n");
		}
	}
	return 0;
}

void show_menu(void)
{
	char* menu[] =
	{
	 "-----Menu------\n",
	 "1. 계좌개설\n",
	 "2. 입    금\n",
	 "3. 출    금\n",
	 "4. 계좌정보 전체 출력\n",
	 "9. 종    료\n"
	};
	int i;
	for (i = 0; i < 6; i++)
		printf("%s", *(menu + i));
}

void make_account(t_account* pt, int* pn)
{
	int id;
	char name[NAME_LEN];
	int balance;

	t_account* p = pt;

	printf("[계좌개설]\n");
	printf("계좌ID: ");
	(void) scanf("%d", &id);
	printf("이  름: ");
	(void) scanf("%s", name);
	printf("입금액: ");
	(void) scanf("%d", &balance);
	printf("\n");

	for (int i = 0; i < *pn; i++) {
		if (p->acc_id == id) {
			printf("이미 설정된 계좌 ID입니다.\n\n");
			return;
		}
		p++;
	}

	p->acc_id = id;
	p->balance = balance;
	strcpy(p->cus_name, name);
	(*pn)++;
}

void deposit_money(t_account* pt, int* pn)
{
	int money;
	int id, i;

	t_account* p = pt;

	printf("[입    금]\n");
	printf("계좌ID: ");
	scanf("%d", &id);
	printf("입금액: ");
	scanf("%d", &money);

	for (i = 0; i < *pn; i++)
	{
		if (p->acc_id == id)
		{
			p->balance += money;
			printf("입금완료\n\n");
			return;
		}
		p++;
	}
	printf("유효하지 않은 ID 입니다.\n\n");
}

void with_draw_money(t_account* pt, int* pn)
{
	int money;
	int id, i;

	t_account* p = pt;

	printf("[출    금]\n");
	printf("계좌ID: ");
	scanf("%d", &id);
	printf("출금액: ");
	scanf("%d", &money);

	for (i = 0; i < *pn; i++)
	{
		if (p->acc_id == id)
		{
			if (p->balance < money)
			{
				printf("잔액부족\n\n");
				return;
			}

			p->balance -= money;  // acc_arr[i].balance = acc_arr[i].balance - money;
			printf("출금완료\n\n");
			return;
		}
		p++;
	}
	printf("유효하지 않은 ID 입니다.\n\n");
}

void show_all_acc_info(t_account* pt, int* pn)
{
	int i;

	t_account* p = pt;

	for (i = 0; i < *pn; i++)
	{
		printf("계좌ID: %d\n", p->acc_id);
		printf("이  름: %s\n", p->cus_name);
		printf("잔  액: %d\n\n", p->balance);
		p++;
	}
}

#endif


// strcat 구현하기
#if 0
void merge(char*, char*, char*);
int main() {
	char input1[100];
	char input2[100];
	char output[200];

	while (1) {
		printf("첫번째 문자열(종료: exit): ");
		fgets(input1, 100, stdin);
		if (!strncmp(input1, "exit", 4)) break;

		printf("두번째 문자열: ");
		fgets(input2, 100, stdin);

		merge(input1, input2, output);

		printf("합친 결과: %s\n", output);

		printf("첫번째 입력 문자 개수: %d\n", (int)strlen(input1) - 1);
		printf("두번째 입력 문자 개수: %d\n", (int)strlen(input2) - 1);
		printf("합친 문자 개수: %d\n", (int)strlen(output - 1));
	}
	return 0;
}

// strcat 쓰지 않고 구현하기
void merge(char* in1, char* in2, char* out) {
#if 1
	char *pout = out;
	char *pin2 = in2;

	strcpy(out, in1);
	out[strlen(out) - 1] = '\0';
	///out[strlen(in1) + strlen(in2)] = '\0';

	while (*pout) {
		pout++;
	}

	while (*pin2) {
		*pout++ = *pin2++;
	}
	*pout = NULL;

#else
	char* p1 = in1;
	char* p2 = in2;

	*(p1 + strlen(p1) - 1) = '\0';
	*(p2 + strlen(p2) - 1) = '\0';

	for (int i = 0; i < strlen(p1) + strlen(p2) + 1; i++) {
		if (i < strlen(p1)) *(out + i) = *(p1 + i);
		else *(out + i) = *(p2 + i - strlen(p1));
	}
#endif
}



#endif

// 포인터로 알파벳 shift
#if 0

void shift_alpha(char*);

int main(void) {
	char alpha[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

	shift_alpha(alpha);

	return 0;
}

void shift_alpha(char* alpha) {
	char saved;
	char* p;

#if 0
	printf("%p\n", alpha);
	printf("%c\n", *(alpha + 0));
	printf("%c\n", *(alpha + 1));
	printf("%c\n", *(alpha + 2));
#endif
	

	for (int i = 0; i <= 26; i++) {
		p = alpha;
		saved = *p;

		printf("%s\n", p);
		for (int n = 0; n < 26; n++) {
			*p = *(p + 1);
			p++;
		}
		*p = saved;
	}
}

#endif

// 증감연산자
#if 0

int main() {

	int a, b;
	int pre, post;

	while (1) {
		printf("a: ");
		scanf("%d", &a);
		if (a == 999) {
			break;
		}
		printf("b: ");
		scanf("%d", &b);

#if 0
		pre = ++a * 3;
		post = b++ * 3;
#else
		pre = (++a) * 3;
		post = (b++) * 3;
#endif
		printf("a = %d, b = %d\n", a, b);
		printf("pre = %d, post = %d\n", pre, post);
	}

	return 0;
}

#endif

#if 0

void join(char*, char*);

int main() {

	char fruit[] = "strawberry";
	char a[] = "I like ";
	char b[] = "apple";
	char merge[] = "\0";

	/*
	sprintf(merge, "%s %s and %s", a, b, fruit);
	printf("%s\n", merge);

	// strcat&strcpy 활용

	strcpy(merge, a);
	strcat(merge, b);
	*/
	join(a, merge);

	printf("%s\n", merge);

	return 0;
}

void join(char* p, char* merge) {
	int len = strlen(merge);
	while (*p) {
		*(merge + len) = *p++;
	}
}

#endif

//ASCII PRINT 줄바꿈
#if 0

int main() {
	char* txt[] =
	{ "NUL", "SOH", "STX", "ETX", "EOT",
	"ENQ", "ACK", "BEL", "BS", "HT", "LF",
	"VT", "FF", "CR", "SO", "SI", "DLE",
	"DC1", "DC2", "DC3", "DC4", "NAK", "SYN",
	"ETB", "CAN", "EM", "SUB", "ESC"," FS", "GS","RS", "US", "DEL"};

	int cursor = 0;

	printf("%70s\n", "ASCII CODE TABLE");
	printf("%70s\n\n", "================");

	for (int i = 0; i < 4; i++) {
		printf("%10s%10s%10s%10s", "DEC", "HEX", "OCT", "CHAR");	
	}
	printf("\n");
	for (int i = 0; i < 4; i++) {
		printf("%10s%10s%10s%10s", "===", "===", "===", "====");
	}
	printf("\n");

	for (int i = 0; i < 32; i++) {
		cursor = i;
		for (int n = 0; n < 4; n++) {
			printf("%10d%10.2x%10o", cursor, cursor, cursor);
			if (cursor < 32) {
				printf("%10s", txt[cursor]);
			}
			else if (cursor == 127) {
				printf("%10s", txt[32]);
			}
			else {
				printf("%10c", cursor);
			}
			cursor += 32;
		}
		printf("\n");

	}

	return 0;
}

#endif

// ASCII PRINT (WITH. TEXT)
#if 0
/*
+----------+----------+----------+----------+----------+----------+
					  ASCII     CODE    TABLE
					  =======================
	DEC		   HEX		   OCT		 CHAR
	===		   ===		   ===		 ====
*/

int main() {
	char *txt[] =
	{ "NUL", "SOH", "STX", "ETX", "EOT",
	"ENQ", "ACK", "BEL", "BS", "HT", "LF",
	"VT", "FF", "CR", "SO", "SI", "DLE",
	"DC1", "DC2", "DC3", "DC4", "NAK", "SYN",
	"ETB", "CAN", "EM", "SUB", "ESC"," FS", "GS","RS", "US", "SPC"};

	printf("%32s\n", "ASCII CODE TABLE");
	printf("%32s\n\n", "================");
	printf("%10s%10s%10s%10s\n", "DEC", "HEX", "OCT", "CHAR");
	printf("%10s%10s%10s%10s\n", "===", "===", "===", "====");

	for (int i = 0; i < 128; i++) {
		printf("%10d%10.2x%10o", i, i, i);
		if (i >= 0 && i <= 32) { // i < 33
			printf("%10s\n", txt[i]);
		}
		else if (i == 127) {
			printf("%10s", "DEL"); // 배열로 통일 옵션 txt[33] = "DEL"
		}
		else {
			printf("%10c\n", i);
		}
	}

	return 0;
}
#endif

// ASCII PRINT
#if 0
/*
+----------+----------+----------+----------+----------+----------+
                      ASCII     CODE    TABLE  
					  =======================
	DEC		   HEX		   OCT		 CHAR
	===		   ===		   ===		 ====
*/

int main() {
	printf("%32s\n", "ASCII CODE TABLE");
	printf("%32s\n\n", "================");
	printf("%10s%10s%10s%10s\n", "DEC", "HEX", "OCT", "CHAR");
	printf("%10s%10s%10s%10s\n", "===", "===", "===", "====");

	for (int i = 0; i < 128; i++) {
		printf("%10d%10.2x%10o%10c\n", i, i, i, i);
	}

	return 0;
}
#endif

#if 0
// Date: 26.2.4
// Author: DongHo Seol

//32
int main() {

	char buff[100];

	while (1) {
		printf("임의의 문자열을 입력(종료:quit)\n: ");
		fgets(buff, 100, stdin);

		if (!(strncmp(buff, "quit", 4))) break; // 지정한길이만큼만비교 strncmp

		for (int i = 0; i < strlen(buff) - 1; i++) {
			if (buff[i] >= 'A' && buff[i] <= 'Z') {
				buff[i] += 0x20; // 0010|0000 = 32
			}
			else if (buff[i] >= 'a' && buff[i <= 'z']) {
				buff[i] -= 0x20;
			}
			else {
				printf("잘못된 입력.");
				continue;
			}
		}
		printf("변환 결과: %s\n", &buff);
	}

	return 0;
}
#endif

#if 0
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Date: 26.2.4
// Author: DongHo Seol

int main() {
	
	// floating 처리

	printf("%lf\n", 3.4);	// 기본-> 소수점 이하 6자리까지 출력

	printf("%.1lf\n", 3.4412);	// 소수점 이하 한 자리

	printf("%.10lf\n", 3.4412);	// 소수점 이하 열 자리

	char ch[10] = "abcdefg"; // abc\0

#if 0
	// 방법1
	ch[0] = 'b';
	ch[1] = 'b';
	ch[2] = 'a';
	ch[3] = '\0';
	printf("ch --> %s\n", &ch);
#endif

	// 방법2
	strcpy(ch, "ABC"); // NULL도들어감
	printf("ch --> %s\n", &ch);

	return 0;
}
#endif

// 사칙연산 자리제한없음
#if 0
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// author dong ho seol

int main() {
	char buff[50];

	int num[2] = {0, 0};
	int result = 0;
	int weight = 1;
	int operator = 0;
	int tempNum = 0;
	int cursor = 0;

	while (1) {
		printf("사칙연산 입력 + - * / (종료:q)\n: ");
		fgets(buff, 50, stdin);
		if (buff[0] == 'q') break;

		cursor = strlen(buff) - 2;

		for (int i = 0; i < sizeof(num) / sizeof(int); i++) {

			for (; cursor >= 0; cursor--) {

				tempNum = buff[cursor] - '0';

				if (tempNum >= 0 && tempNum <= 9) {
					num[i] += tempNum * weight;
					weight *= 10;
				}
				else {
					operator = cursor--;
					break;
				}
			}
			weight = 1;
		}
		cursor = 0;

		switch (buff[operator]) {
		case '+':
			result = num[1] + num[0];
			break;
		case '-':
			result = num[1] - num[0];
			break;
		case '*':
			result = num[1] * num[0];
			break;
		case '/':
			result = num[1] / num[0];
			break;
		default:
			printf("Invalid input.\n");
			return 0;
		}

		printf("%d %c %d = %d\n", num[1], buff[operator], num[0], result);

		num[0] = 0;
		num[1] = 0;
	}
} 
#endif

// 한 자리 사칙연산
#if 0
#include <stdio.h>

int main(){
	char buff[10];
	int result = 0;
	int num1 = 0;
	int num2 = 0;

	while (1) {
		printf("사칙연산입력\n: ");
		fgets(buff, 10, stdin);
		if (buff[0] == 'q') break;

		num1 = atoi(buff);
		num2 = atoi(buff + 2);

		switch (buff[1]) {
		case '+': 
			result = num1 + num2; 
			break;
		case '-':
			result = num1 - num2;
			break;
		case '*':
			result = num1 * num2;
			break;
		case '/':
			result = num1 / num2;
			break;
		default:
			printf("Invalid operator.\n");
			continue;
		}
		printf("= %d\n", result);
		//printf("%c %c %c = %c\n", num1 + 0x30, buff[1], num2 + 0x30, result + 0x30);
	}
}
#endif

#if 0
#include <stdio.h>

/*
	- program name: test.c
	- ver: 1.0
	- author: Dong-Ho Seol
	- written date: 26.2.4
	- function: c언어 test
*/

int main() {
	printf("Hello D.H. Seol\n");

	return 0; // 0 정상 / -1 심각한 에러
}
#endif

#if 0
#include <stdio.h>	//printf fgets scanf gets 등
#include <string.h> // strcpy strncmp strcmp strlen 등
int main() {

	// Variable: 자료 저장 공간
	char c; // 1byte -127 ~ 127
	
	unsigned char uc = 0xff; // 0x00 ~ 0xff(255)
	// unsigned char uc = 0b11111111; // binary
	// unsigned char uc = 255; // decimal
	short s; // 2bytes
	unsigned short us; // 0x00 ~ 0xffff(65535)
	int i; // 4bytes
	unsigned int ui; // 
	long l; // 4bytes

	uc = 0xff;
	uc = 0377; // octal -> 0

	printf("uc dec: %d\n", uc);		// decimal 출력
	printf("uc hex: 0x%0x\n", uc);	// hexa 출력
	printf("uc oct: 0%o\n", uc);	// octal 출력
	uc++;	// uc = uc + 1
			// overflow 발생 1111 + 1 = 10000 -> 0000만 남음 = 0

	printf("uc dec: %d\n", uc);		// decimal 출력
	printf("uc hex: 0x%0x\n", uc);	// hexa 출력
	printf("uc oct: 0%o\n", uc);	// octal 출력
	
	// 메모리 점유 공간 확인
	printf("size of char: %d\n", (int)sizeof(char));
	printf("size of unsigned char: %d\n", (int)sizeof(unsigned char));

	printf("size of short: %d\n", (int)sizeof(unsigned short));
	printf("size of unsigned short: %d\n", (int)sizeof(unsigned short));

	printf("size of int: %d\n", (int)sizeof(int));
	printf("size of unsigned int: %d\n", (int)sizeof(unsigned int));

	printf("size of long: %d\n", (int)sizeof(long));
	printf("size of float: %d\n", (int)sizeof(float));
	printf("size of double: %d\n", (int)sizeof(double));

	// 'A', "A"
	printf("A: %c size: %d\n", 'A', (int)sizeof((char)'A'));
	printf("A: %s size: %d\n", "A", (int)sizeof("A"));		// A\0 -> NULL들어감

	char array[10]; // 배열은 2의 배수로
	char a[] = "ABCDEFG";
	int iarray[2];

	printf("array size: %d\n", (int)sizeof(array));		//10bytes
	printf("a size: %d\n", (int)sizeof(a));				// 8bytes
	printf("iarray size: %d\n", (int)sizeof(iarray));	// 8bytes

	printf("a strlen: %d\n\n", (int)strlen(a));			// strlen = 7

	// #1 / a배열 0, 2, 4 출력
	for (int i = 0; i < 5; i += 2) {
		printf("a[%d] = %c\n", i, a[i]);
	}
	
	// #2 / a배열 2부터 끝까지
	printf("a[2]~[4]: %s\n", a + 2);

	// #3 / a배열 내용 이름3글자로 바꿔 출력
	strcpy(a, "SDH");
	printf("a: %s\n", a);

	return 0; // 0 정상 / -1 심각한 에러
}
#endif

#if 0
#include <stdio.h>

int main() {
	char buffer[10];
	
	while (1) {
		printf("임의의 문자를 입력 종료(q)\n: ");
		fgets(buffer, 10, stdin);
		if (*buffer == 'q') break;
		printf("입력 문자 %c의 ascii: %0x",buffer[0], buffer[0]);
	}
	return 0;
}
#endif