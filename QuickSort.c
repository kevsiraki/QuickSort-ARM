#include <stdio.h>

int partition(int array[], int low, int high) {
    int pivot = array[high];
    int i = (low - 1);
    for (int j = low; j < high; j++) {
        if (array[j] <= pivot) {
            i++;
            int temp = array[i];
            array[i] = array[j];
            array[j] = temp;
        }
    }
    int temp = array[i + 1];
    array[i + 1] = array[high];
    array[high] = temp;
    return (i + 1);
}

void quickSort(int array[], int low, int high) {
    if (low < high) {
        int pi = partition(array, low, high);
        quickSort(array, low, pi - 1);
        quickSort(array, pi + 1, high);
    }
}

int main() {
    int array[] = {82, 45, 17, 64, 29, 53, 98, 12, 36, 71, 50, 24, 88, 5, 42, 67, 11, 78, 33, 60};
    int length = sizeof(array) / sizeof(array[0]);
    quickSort(array, 0, length - 1);
    printf("Sorted array: ");
    for (int i = 0; i < length; i++) {
        printf("%d ", array[i]);
    }
    printf("\n");
    return 0;
}
