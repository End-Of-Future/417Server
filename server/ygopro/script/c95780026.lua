--机械维度 快鲨艇
function c95780026.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95780026,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,95780026+EFFECT_COUNT_CODE_OATH)		
	e1:SetCondition(c95780026.spcon)
	c:RegisterEffect(e1)
	--spsummon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95780026,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,95780027)
	e2:SetCondition(c95780026.spcon2)
	e2:SetCost(c95780026.spcost)
	e2:SetTarget(c95780026.sptg2)
	e2:SetOperation(c95780026.spop2)
	c:RegisterEffect(e2)
end
function c95780026.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c95780026.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) 
end	
function c95780026.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c95780026.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())==1
end
function c95780026.spfilter(c,e,tp)
	return c:IsSetCard(0x4e11) and not c:IsCode(95780026) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95780026.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c95780026.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c95780026.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local ct=math.min(ft,2)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95780026.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,ct,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c95780026.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(95780026,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c95780026.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c95780026.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
		and not (c:IsRace(RACE_MACHINE) and c:IsType(TYPE_SYNCHRO))
end