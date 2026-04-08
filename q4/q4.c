#include<stdio.h>
#include<dlfcn.h>
#include<string.h>
typedef int (*func)(int, int);

int main(){
    while(1){
    char name[10];
    int first, second;
    scanf("%s %d %d", name, &first, &second);
    char filename[200];
    snprintf(filename, 20,"./lib%s.so",  name);
    //printf("%s\n", filename);
    void *handle  = dlopen(filename, RTLD_LAZY);
    func function = dlsym(handle, name);
    int result = function(first, second);
    printf("%d\n", result);
    }



    return 0;
}