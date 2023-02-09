--激流-归召灵
function c27822006.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_WATER),2,2) 
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27822006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,27822006) 
	e1:SetTarget(c27822006.sptg)
	e1:SetOperation(c27822006.spop)
	c:RegisterEffect(e1) 
end
c27822006.XXSplash=true 
function c27822006.spfil(c,e,tp,zone)
	return c.XXSplash and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function c27822006.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c27822006.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c27822006.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f) 
	local g=Duel.GetMatchingGroup(c27822006.spfil,tp,LOCATION_GRAVE,0,nil,e,tp,zone)
	if g:GetCount()>0 and zone~=0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst() 
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c27822006.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c27822006.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsRace(RACE_AQUA) 
end













