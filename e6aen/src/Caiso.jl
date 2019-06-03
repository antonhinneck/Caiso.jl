## This package implements function to access
## the REST API of the California System
## Operator Organization http://www.caiso.com/Pages/default.aspx
######----------------------------------------------------------

__precompile__(true)
module Caiso

# REQUIRES: Dates, HTTP, CSV, Dates
#--------------------------------------
        using HTTP, JSON, CSV, DataFrames, Dates

# QUERIES -----------------------------------------
#--------------------------------------------------

        function caiso_query_demand(day_1::Date,
                                    day_2::Date;
                                    verbose = false)

                @assert (day_1 <= day_2) "Assertion Error: Day 1 <= Day 2"
                @assert (day_1 >= Date(2018, 04, 10)) "Assertion Error: First entry was sampled on April 10th, 2018."

                url_root::String = "http://www.caiso.com/outlook/SP/history/"
                url_end::String = "/demand.csv"
                url::String = ""

                current_date::Date = day_1

                current_date_year_string::String = ""
                current_date_month_string::String = ""
                current_date_day_string::String = ""

                counter = 1
                net_demand = Vector{Array{Int64, 1}}()
                dates = Vector{Dates.Date}()

                while current_date != day_2 + Dates.Day(1)

                        # Process Year
                        #-------------
                        current_date_year_string = string(year(current_date))

                        # Process Month
                        #--------------
                        if month(current_date) < 10
                                current_date_month_string = string(0) * string(month(current_date))
                        else
                                current_date_month_string = string(month(current_date))
                        end

                        # Process Day
                        #------------
                        if day(current_date) < 10
                                current_date_day_string = string(0) * string(day(current_date))
                        else
                                current_date_day_string = string(day(current_date))
                        end

                        # Build GET URL
                        #--------------
                        url =   url_root *
                                current_date_year_string *
                                current_date_month_string *
                                current_date_day_string *
                                url_end

                        data = HTTP.request("GET", url, [])
                        data_df = dropmissing(CSV.read(data.body))

                        push!(net_demand, data_df[:, 4])
                        push!(dates, current_date)

                        current_date += Dates.Day(1)

                        # Output
                        #-------
                        if verbose
                                print("\nAPI REQUEST PROCESSED:\n")
                                print(url,"\n")
                        end

                end

                return net_demand, dates
        end

# Module's end
#-------------
end
