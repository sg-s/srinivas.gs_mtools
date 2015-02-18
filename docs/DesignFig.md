# DesignFig.m

interactively design figures with as many subplots as you want, arranged in whatever manner you want. Never use `subplot()` again. WYSIWYG. 

Designing this arrangement in `DesignFig:`

![](design.png)

generates this code:

```matlab
fig_handle=figure('Units','pixels','Position',[135 13 900 843],'Color','w');
clf(fig_handle);
axes_handles(1)=axes('Units','pixels','Position',[42.15 716.55 590.1 84.3]);
axes_handles(2)=axes('Units','pixels','Position',[42.15 590.1 590.1 126.45]);
axes_handles(3)=axes('Units','pixels','Position',[42.15 484.725 590.1 105.375]);
axes_handles(4)=axes('Units','pixels','Position',[695.475 653.325 147.525 147.525]);
axes_handles(5)=axes('Units','pixels','Position',[695.475 484.725 147.525 147.525]);
axes_handles(6)=axes('Units','pixels','Position',[84.3 252.9 189.675 189.675]);
axes_handles(7)=axes('Units','pixels','Position',[84.3 42.15 189.675 168.6]);
axes_handles(8)=axes('Units','pixels','Position',[337.2 252.9 189.675 189.675]);
axes_handles(9)=axes('Units','pixels','Position',[337.2 42.15 189.675 168.6]);
axes_handles(10)=axes('Units','pixels','Position',[590.1 252.9 189.675 189.675]);
axes_handles(11)=axes('Units','pixels','Position',[590.1 42.15 189.675 168.6]);
```

gives you this figure, ready to use:

![](plot.png)

`DesignFig` allows you to save designs for later edits, and generates the code to make the figure. 