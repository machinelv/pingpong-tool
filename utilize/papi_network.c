#include <stdio.h>
#include <stdlib.h>
#include <papi.h>

int main() {
    int retval;
    // 初始化 PAPI 库
    retval = PAPI_library_init(PAPI_VER_CURRENT);
    if (retval != PAPI_VER_CURRENT) {
        printf("PAPI library initialization error: %d\n", retval);
        exit(1);
    }

    // 创建一个事件集合
    int event_set = PAPI_NULL;
    retval = PAPI_create_eventset(&event_set);
    if (retval != PAPI_OK) {
        printf("PAPI eventset creation error: %d\n", retval);
        exit(1);
    }

    // 事件选择：根据实际需求选择网络或IB事件
    // 这里选择了一些常见的性能计数事件作为示例
    // 你需要根据具体的硬件支持来选择合适的事件代码
    retval = PAPI_add_event(event_set, PAPI_TOT_INS);  // Total Instructions
    if (retval != PAPI_OK) {
        printf("Error adding event: %d\n", retval);
        exit(1);
    }

    retval = PAPI_add_event(event_set, PAPI_LST_INS);  // Load Instructions
    if (retval != PAPI_OK) {
        printf("Error adding event: %d\n", retval);
        exit(1);
    }

    // 启动事件计数
    retval = PAPI_start(event_set);
    if (retval != PAPI_OK) {
        printf("Error starting events: %d\n", retval);
        exit(1);
    }

    // 执行需要监控的代码（网络或IB相关操作）
    // 在此处放置网络通信或InfiniBand操作的代码

    // 停止事件计数
    retval = PAPI_stop(event_set, NULL);
    if (retval != PAPI_OK) {
        printf("Error stopping events: %d\n", retval);
        exit(1);
    }

    // 获取事件计数器的值
    long long int values[2];
    retval = PAPI_read(event_set, values);
    if (retval != PAPI_OK) {
        printf("Error reading events: %d\n", retval);
        exit(1);
    }

    // 打印事件计数器值
    printf("Total Instructions: %lld\n", values[0]);
    printf("Load Instructions: %lld\n", values[1]);

    // 清理工作
    retval = PAPI_cleanup_eventset(event_set);
    if (retval != PAPI_OK) {
        printf("Error cleaning up eventset: %d\n", retval);
        exit(1);
    }
    retval = PAPI_destroy_eventset(&event_set);
    if (retval != PAPI_OK) {
        printf("Error destroying eventset: %d\n", retval);
        exit(1);
    }

    // 结束 PAPI 库
    PAPI_shutdown();
    return 0;
}