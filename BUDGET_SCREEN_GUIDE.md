# 💰 Budget Management - User Guide

## Quick Start

### 1️⃣ Set Your Budgets
1. Open **Budget Management** from bottom navigation
2. Tap the **"Set Budgets"** button (purple gradient, top right)
3. For each category:
   - See your current spending
   - Enter monthly budget limit
4. Tap **"Save Budgets"**

### 2️⃣ Monitor Your Spending

#### Overview Card (Top)
- **Green**: You're doing great! (0-80% used)
- **Yellow**: Be careful! (80-100% used)
- **Red**: Over budget! Need to cut back

**What You See**:
- Total Budget amount
- Money Spent so far
- Money Remaining (or Over Budget amount)
- Progress bar showing usage

#### Quick Stats
- **Categories**: How many you're tracking
- **Over Budget**: Categories that exceeded limits (0 = excellent!)

### 3️⃣ Understand Category Cards

#### Card Colors & Borders
| Look | Meaning | Action |
|------|---------|--------|
| ⚪ No border | Under 80% | Keep going! |
| 🟡 Yellow border | 80-100% | Slow down |
| 🔴 Red border | Over 100% | Stop spending! |

#### Card Information
- **Icon**: Category type (🍔 Food, 🚗 Transport, etc.)
- **Percentage Badge**: How much budget used
  - Has ⚠️ warning icon if over/near limit
- **Spent/Budget**: "₹5K / ₹10K"
- **Status**: 
  - "₹5K left" (green ⬇️ arrow)
  - "₹2K over budget" (red ⬆️ arrow)
- **Progress Bar**: Visual indicator
  - Green = healthy
  - Yellow = warning
  - Red = over budget

### 4️⃣ View Category Details

**Tap any category card** to see:

#### Budget Overview Box
- Color changes based on status (green/yellow/red)
- Shows: Spent vs Remaining
- Progress bar

#### Smart Insights 💡
Get daily spending recommendations:
> "You can spend ₹500/day for remaining 15 days"

This helps you stay on track!

#### Recent Transactions
- Last 5 expenses in this category
- See when and how much you spent
- Helps identify spending patterns

## 🎯 Tips for Success

### Setting Realistic Budgets
1. **Review Past Spending**: Check your transaction history
2. **Start Conservative**: Better to have leftover than overspend
3. **Adjust Monthly**: Fine-tune based on actual needs

### Categories to Budget
- 🍔 **Food & Dining**: Groceries + restaurants
- 🚗 **Transportation**: Fuel, parking, public transport
- 🏠 **Housing**: Rent, utilities, maintenance
- 🎬 **Entertainment**: Movies, hobbies, subscriptions
- 🛍️ **Shopping**: Clothes, gadgets, personal items
- 💊 **Healthcare**: Medicine, doctor visits
- 📚 **Education**: Books, courses, supplies
- 💰 **Other**: Miscellaneous expenses

### Budget Alerts
Watch for these signals:

| Signal | Meaning | What To Do |
|--------|---------|------------|
| Green card | Healthy | Continue current spending |
| Yellow border | Warning zone | Review upcoming expenses |
| Red border | Overspending | Stop non-essential purchases |
| "Over Budget Alert" | Multiple categories over | Review entire budget plan |

## 📊 Understanding the Pie Chart

### What It Shows
- Each slice = one category's spending
- Slice size = percentage of total spending
- Only shows categories with transactions

### How to Read It
- **Large slices**: Your biggest spending categories
- **Percentages**: Shown on slices (when >10% of total)
- **Center number**: Total money spent this month
- **Side legend**: All categories with icons

### Empty Chart?
If you see "No spending data":
- Add some transactions first
- Categories appear automatically when you spend

## 💡 Smart Features

### Automatic Calculations
- **Total Budget**: Sum of all category budgets
- **Total Spent**: Real-time from transactions
- **Remaining**: Updates instantly
- **Percentage**: Calculated automatically
- **Daily Recommendation**: Accounts for days left in month

### Persistent Storage
- Your budgets are saved automatically
- Survive app restarts
- Monthly spending resets each month
- Budget limits stay the same (until you change them)

### Color Intelligence
The app uses smart colors to help you:
- **Green (#10B981)**: Safe zone
- **Yellow (#FBBA24)**: Caution zone
- **Red (#EF4444)**: Danger zone
- **Blue (#3B82F6)**: Helpful info
- **Purple (#6366F1)**: Actions/buttons

## 🔄 Monthly Workflow

### Week 1: Set Budget
1. Set budget limits for each category
2. Review last month's spending
3. Adjust budgets if needed

### Week 2: Monitor
1. Check overview card daily
2. Watch for yellow warnings
3. Adjust spending if approaching limits

### Week 3: Mid-Month Review
1. Tap categories to see details
2. Check daily recommendations
3. Make corrections if over budget

### Week 4: Final Sprint
1. Red borders? Stop spending in that category
2. Use daily recommendations
3. Plan better for next month

### Month End
1. Review what worked/didn't work
2. Adjust budgets for next month
3. Start fresh!

## 🎨 Visual Guide

### Budget Screen Layout
```
┌─────────────────────────────────────┐
│ Budget Manager          [+ Chart]   │ ← Header
├─────────────────────────────────────┤
│                                     │
│  [GREEN/YELLOW/RED OVERVIEW CARD]   │ ← Status
│  Total Budget: ₹50,000              │
│  Spent: ₹35,000 | Remaining: ₹15K   │
│  ████████████░░░░░░ 70%             │
│                                     │
├─────────────────────────────────────┤
│  [Categories: 8]  [Over Budget: 0]  │ ← Stats
├─────────────────────────────────────┤
│                                     │
│     [PIE CHART WITH LEGEND]         │ ← Visualization
│                                     │
├─────────────────────────────────────┤
│ Budget by Category    [Set Budgets] │ ← Action
├─────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐        │
│  │🍔 Food    │  │🚗 Trans  │        │ ← Category
│  │ 65% ✓    │  │ 95% ⚠️   │         │   Cards
│  │₹6.5K/₹10K│  │₹9.5K/₹10K│        │
│  │₹3.5K left│  │₹500 left │        │
│  └──────────┘  └──────────┘        │
└─────────────────────────────────────┘
```

### Category Card States
```
HEALTHY (No border)
┌─────────────┐
│ 🍔  [55%]   │
│ Food        │
│ ₹5.5K/₹10K  │
│ ₹4.5K left  │
│ ████░░░░    │ ← Green
└─────────────┘

WARNING (Yellow border)
┌─────────────┐ 🟡
│ 🚗  [85%⚠️] │
│ Transport   │
│ ₹8.5K/₹10K  │
│ ₹1.5K left  │
│ ████████░   │ ← Yellow
└─────────────┘

ALERT (Red border)
┌─────────────┐ 🔴
│ 🛍️  [105%⚠️]│
│ Shopping    │
│ ₹10.5K/₹10K │
│ ₹500 over!  │
│ ████████████│ ← Red
└─────────────┘
```

## 🆘 Troubleshooting

### "No Budget Categories Yet"
**Problem**: Empty category grid  
**Solution**: Add transactions first - categories auto-create

### Budget Won't Save
**Problem**: Clicking Save doesn't work  
**Solution**: Make sure you entered valid numbers (no letters or special characters)

### Wrong Category Total
**Problem**: Spending doesn't match transactions  
**Solution**: Check if transactions are marked as "Expense" type

### Can't See All Categories
**Problem**: Missing categories in grid  
**Solution**: Scroll down - it's a scrollable grid

## 📝 Pro Tips

1. **Set Smaller Budgets**: Easier to stay under than over
2. **Check Daily**: Quick glance keeps you accountable
3. **Use Insights**: Follow daily spend recommendations
4. **Review Transactions**: Tap cards to see where money went
5. **Adjust Monthly**: Life changes, budgets should too

## 🎉 Success Metrics

You're doing great when you see:
- ✅ All cards with no borders (under 80%)
- ✅ "Over Budget: 0" in stats
- ✅ Green overview card
- ✅ Positive "remaining" amounts
- ✅ Progress bars mostly green

---

**Remember**: Budgets are tools, not restrictions. They help you spend wisely, not stop spending entirely! 🌟
