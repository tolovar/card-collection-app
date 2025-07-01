export function debounce<F extends (...args: any[]) => void>(func: F, wait: number) {
    let timeout: ReturnType<typeof setTimeout>;
    return (...args: Parameters<F>) => {
        clearTimeout(timeout);
        timeout = setTimeout(() => func(...args), wait);
    };
}