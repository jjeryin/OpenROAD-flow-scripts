export PLATFORM               = asap7

export DESIGN_NICKNAME        = ibex
export DESIGN_NAME            = ibex_core

export VERILOG_FILES         = $(sort $(wildcard ./designs/src/$(DESIGN_NICKNAME)/*.v))
export SDC_FILE              = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

#export CORE_UTILIZATION       =  40
#export CORE_ASPECT_RATIO      = 1
#export CORE_MARGIN            = 2
#export PLACE_DENSITY_LB_ADDON  = 0.20

export CORE_UTILIZATION       =  44
export CORE_ASPECT_RATIO      = 1.9918393516379576
export CORE_MARGIN            = 2
export PLACE_DENSITY_LB_ADDON  = 0.2260664791073356

CTS_CLUSTER_SIZE = 148
CTS_CLUSTER_DIAMETER = 237

CELL_PAD_IN_SITES_GLOBAL_PLACEMENT = 2
CELL_PAD_IN_SITES_DETAIL_PLACEMENT = 0

export ENABLE_DPO = 0

export DFF_LIB_FILE           = $($(CORNER)_DFF_LIB_FILE)
