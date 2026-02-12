//=== 아래#2 ===  
#include <stdio.h>
#include <string.h>
#define NAME_LEN   20

typedef struct 
{
	int acc_id;      // 계좌번호
	int balance;    // 잔    액
	char cus_name[NAME_LEN];   // 고객이름
} t_account;

void show_menu(void);           // 메뉴출력
void make_account(t_account  *t, int *n);        // 계좌개설을 위한 함수
void deposit_money(t_account  *t, int *n);         // 입    금
void with_draw_money(t_account  *t, int *n);     // 출    금
void show_all_acc_info(t_account  *t, int *n);     // 잔액조회

enum {MAKE=1, DEPOSIT, WITHDRAW, INQUIRE, EXIT=9};


int main()  // int main(argc, char *argv[])
{
	int choice;
	t_account acc_arr[100];   // Account 저장을 위한 배열
	int acc_num=0;           // 저장된 Account 수
	
	while(1)
	{
		show_menu();
		printf("선택: ");  
		scanf("%d", &choice);
		printf("\n");
		
		switch(choice)
		{
		case MAKE:
			make_account(acc_arr, &acc_num); 
			break;
		case DEPOSIT:
			deposit_money(acc_arr, &acc_num); 
			break;
		case WITHDRAW: 
			with_draw_money(acc_arr, &acc_num); 
			break;
		case INQUIRE:
			show_all_acc_info(acc_arr, &acc_num); 
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
	char *menu[] =
	{
	 "-----Menu------\n", 
	 "1. 계좌개설\n",
	 "2. 입    금\n",
         "3. 출    금\n",
	 "4. 계좌정보 전체 출력\n",
	 "9. 종    료\n" 		
	};
	int i;
	
	for (i=0; i < 6; i++)
		printf("%s", *(menu+i));
}

void make_account(t_account  *t, int *n) 
{
	int id;
	char name[NAME_LEN];
	int balance;
	
	printf("[계좌개설]\n");
	printf("계좌ID: ");	
	scanf("%d", &id);
	printf("이  름: ");	
	scanf("%s", name);
	printf("입금액: ");	
	scanf("%d", &balance);
	printf("\n");

    t[*n].acc_id = id;
    strcpy(t[*n].cus_name, name);
    t[*n].balance = balance;
    (*n)++;
}

void deposit_money(t_account  *t, int *n) 
{
	int money;
	int id, i;
	
	printf("[입    금]\n");
	printf("계좌ID: ");
	scanf("%d", &id);
	printf("입금액: ");
	scanf("%d", &money);
	
	for (i=0; i<*n; i++)
	{
		if(t[i].acc_id==id)
		{
			t[i].balance += money;
			printf("입금완료\n\n");
			return;
		}
	}
	printf("유효하지 않은 ID 입니다.\n\n");
}


void with_draw_money(t_account  *t, int *n)
{
	int money;
	int id, i;
	
	printf("[출    금]\n");
	printf("계좌ID: ");
	scanf("%d", &id);
	printf("출금액: ");
	scanf("%d", &money);
	
	for(i=0; i<*n; i++)
	{
		if(t[i].acc_id==id)
		{
			if(t[i].balance < money)
			{
				printf("잔액부족\n\n");
				return;
			}

			t[i].balance -= money;  // acc_arr[i].balance = acc_arr[i].balance - money;
			printf("출금완료\n\n");
			return;
		}
	}
	printf("유효하지 않은 ID 입니다.\n\n");
}

void show_all_acc_info(t_account  *t, int *n)
{
	int i;
	
	for(i=0; i<*n; i++)
	{
		printf("계좌ID: %d\n", t[i].acc_id);
		printf("이  름: %s\n", t[i].cus_name);
		printf("잔  액: %d\n\n", t[i].balance);
	}
}