export function asArray<T>(value?: T | T[] | undefined): T[] {
  if (value === undefined) {
    return [];
  }

  if (Array.isArray(value)) {
    return value;
  }

  return [value];
}

export const isNonEmptyArray = <T>(value: T | T[]): value is NonNullable<T>[] => {
  return value !== undefined && Array.isArray(value) && value.length > 0;
}
