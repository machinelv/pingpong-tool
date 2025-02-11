import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os


def plot_histogram(data:pd.DataFrame, x:str, title:str, save_path:str, file_name:str):
    plt.figure(figsize=(12, 6))
    plt.hist(data[x], bins=35, alpha=0.5, color='blue', edgecolor='black')
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
    
    plt.savefig(os.path.join(save_path, f'{file_name}-{x.replace('/','per')}.png'))
    plt.close()

def plot_bar_with_discrete_x(data:pd.DataFrame, x:str, stat:str, title:str, save_path:str, file_name:str):
    fig, ax = plt.subplots(figsize=(8, 4))
    x_ticks = []
    interleaved_vals = []
    single_vals = []
    nodes_list = data[x].unique()
    # Use the predefined node pairs: first element for interleaved, second for single.
    for nodes in nodes_list:
    # Query data rows for the corresponding node and task type.
        query_inter = data[(data[x] == nodes) & (data['task_type'] == 'interleaved')]
        query_single = data[(data[x] == nodes) & (data['task_type'] == 'single')]
        # If multiple rows exist, take the mean of the statistic.
        val_inter = query_inter[stat].mean() if not query_inter.empty else 0
        val_single = query_single[stat].mean() if not query_single.empty else 0
        interleaved_vals.append(val_inter)
        single_vals.append(val_single)
        x_ticks.append(f"{nodes}")
    # Set positions and bar width for each group.
    x = np.arange(len(x_ticks))
    width = 0.35
    ax.bar(x - width/2, single_vals, width, label='single', color='orange')
    ax.bar(x + width/2, interleaved_vals, width, label='interleaved', color='blue')
    ax.set_xticks(x)
    ax.set_xticklabels(x_ticks)

    rate = np.array(interleaved_vals)/np.array(single_vals) - 1
    rate = rate * 100
    ax2 = ax.twinx()
    ax2.plot(x, rate, color='red', marker='o', linestyle='--', label='Ratio')
    ax2.set_ylabel('Interleaved/Single Ratio (%)')
    for i, r in enumerate(rate):
        ax2.text(x[i], r, f"{r:.2g}%", ha='center', va='bottom', color='red')
    # ax2.legend(loc='upper right')

    ax.set_title(title)
    ax.legend()
    plt.tight_layout()
    plt.savefig(os.path.join(save_path, file_name+'.png'))
    plt.close()