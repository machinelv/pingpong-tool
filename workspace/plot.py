import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os


def plot_histogram(data:pd.DataFrame, x:str, title:str, save_path:str, file_name:str):
    plt.figure(figsize=(12, 6))
    plt.hist(data[x], bins=20, alpha=0.5, color='blue', edgecolor='black')
    mean_val = data[x].mean()
    std_val = data[x].std()

    if 'time' in x:
        p99_val = data[x].quantile(0.99)
        p95_val = data[x].quantile(0.95)
    else:
        p99_val = data[x].quantile(0.01)
        p95_val = data[x].quantile(0.05)

    plt.axvline(mean_val, color='red', linestyle='--', label=f'Mean={mean_val:.4g}, STD={std_val:.2f}')
    plt.axvline(p99_val, color='green', linestyle='--', label=f'99th={p99_val:.4g}')
    plt.axvline(p95_val, color='orange', linestyle='--', label=f'95th={p95_val:.4g}')

    plt.legend()
    plt.xlabel(x)
    plt.ylabel('Frequency')
    plt.title(title)
    plt.tight_layout()
    # plt.savefig(os.path.join(save_path, f'{file_name}.png'))
    # plt.close()