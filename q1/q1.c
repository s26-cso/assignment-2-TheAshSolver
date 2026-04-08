#include<stdio.h>

struct Node{
    int val;
    struct Node *left;  
    struct Node *right;
};
extern struct Node *make_node(int val);
extern struct Node *insert(struct Node *root, int val);
extern struct Node *get(struct Node *root, int val);
extern int getAtMost(int val, struct Node *root);
int main(){
    struct Node *new=  make_node(5);
    new = insert(new, 1);
    new = insert(new, 8);
    new= insert(new, 0);
    new= insert(new, 20);
    printf("%d", getAtMost(1000, new));





    return 0;
}