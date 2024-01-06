indicator(title="Simple Exponential Smoothing", shorttitle="SES", overlay=true)

// Your chosen length for the EMA
length = 14

// Calculate the EMA as an approximation of simple exponential smoothing
smoothed_close = ta.ema(close, length)

// Plot the EMA on the chart
plot(smoothed_close, title="Smoothed Close", color=color.blue)

// Plot the forecasted value as a horizontal line
var line forecast_line = na

// Function to delete the existing forecast line
forecast_length = 1 // Forecasting 1 period ahead
forecasted_value = ta.valuewhen(1, smoothed_close, 0)

// Update or create the forecast line at the last bar
if barstate.islast
    // If the forecast line already exists, delete it
    if not na(forecast_line)
        line.delete(forecast_line)
    
    // Draw a new forecast line
    forecast_line := line.new(bar_index[1], forecasted_value, bar_index, forecasted_value, width=2, color=color.red, style=line.style_dotted)
    line.set_extend(forecast_line, extend.none)
plot(close)