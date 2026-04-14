#include<stdio.h>
#include<dlfcn.h>
#include<string.h>
typedef int (*func)(int, int);

int main(){
    char name[10];
    int first, second;
    while(scanf("%s %d %d", name, &first, &second)==3){
   
    
    char filename[200];
    snprintf(filename, sizeof(filename),"./lib%s.so",  name);
    //printf("%s\n", filename);
    void *handle  = dlopen(filename, RTLD_LAZY);
    if(handle==NULL){
        printf("Error with file loading\n");
        continue;

    }
    func function = dlsym(handle, name);
    if(function==NULL){
        printf("Error iwht file loading");
        dlclose(handle);
        continue;
    }
    int result = function(first, second);
    dlclose(handle);
    printf("%d\n", result);
    }



    return 0;
}