## This package implements function to access
## the REST API of the California System
## Operator Organization http://www.caiso.com/Pages/default.aspx
######----------------------------------------------------------
using HTTP, JSON, CSV, DataFrames, Dates


__precompile__(true)
module Caiso

# REQUIRES: Dates, HTTP, CSV, Dates
#--------------------------------------


# QUERIES -----------------------------------------
#--------------------------------------------------

        function caiso_query_demand(day_1::Date,
                                    day_2::Date;
                                    verbose = false)

                input_valid = true
                if day_1 > day_2
                        print("Error (caiso_query_demand): Day 1 > Day 2.")
                        input_valid = false
                end
                if day_1 < Date(2018, 04, 10)
                        print("Error (caiso_query_demand): First entry on April 10th, 2018.")
                        input_valid = false
                end

                if input_valid

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
                end

                return net_demand, dates
        end

# Module's end
#-------------
end
