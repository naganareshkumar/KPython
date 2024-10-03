### BUbble sort
##
##def swap(first, second):
##    return second, first
##
### 5,4,3,2
##def bubbleSort(arr):
##    l = len(arr)
####    maxitem = max(arr)
####    minitem = min(arr)
####    arr[0]=minitem
####    arr[l-1] = maxitem
##    
##    for i in range(1,l):
##        if arr[i-1] > arr[i]:
##            arr[i-1], arr[i] = swap(arr[i-1],arr[i])
##    return bubbleSort(arr)
##print(bubbleSort([5,4,3,2,1,7,9,6]))

def bubbleSort(arr):
    l = len(arr)
    for i in range(l):
        swapped = False
        for j in range(0, l-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]
                swapped = True
        if not swapped:
            break
    return arr

print(bubbleSort([5, -1, 3, -2, 0, 1, 7, 9, 6]))
