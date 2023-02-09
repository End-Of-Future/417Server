--激流之渊灵
function c27822029.initial_effect(c)
	--SpecialSummon 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_GRAVE) 
	e1:SetCost(c27822029.spcost) 
	e1:SetTarget(c27822029.sptg) 
	e1:SetOperation(c27822029.spop) 
	c:RegisterEffect(e1) 
	--sb 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e2:SetCondition(c27822029.sbcon)
	e2:SetTarget(c27822029.sbtg) 
	e2:SetOperation(c27822029.sbop) 
	c:RegisterEffect(e2) 
	local e3=e2:Clone() 
	e3:SetCode(EVENT_REMOVE) 
	c:RegisterEffect(e3) 
end 
c27822029.XXSplash=true 
function c27822029.ctfil(c) 
	return c.XXSplash and c:IsAbleToRemoveAsCost()  
end 
function c27822029.spcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c27822029.ctfil,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end 
	local g=Duel.SelectMatchingCard(tp,c27822029.ctfil,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())  
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end  
function c27822029.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c27822029.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) ~=0 then   
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end 
end 
function c27822029.sbfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(27822029) and c:IsLocation(LOCATION_GRAVE) and c:IsCanBeEffectTarget(e)  
end 
function c27822029.sbcon(e,tp,eg,ep,ev,re,r,rp) 
	local rc=e:GetHandler():GetReasonCard()
	return rc and rc:GetMaterial():Filter(c27822029.sbfil,nil,e,tp):GetCount()>0   
end   
function c27822029.sbtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)   
	if chk==0 then return e:GetHandler():IsReason(REASON_MATERIAL) and e:GetHandler():IsReason(REASON_SYNCHRO) end 
	local rc=e:GetHandler():GetReasonCard() 
	local rg=rc:GetMaterial():Filter(c27822029.sbfil,nil,e,tp) 
	local sg=rg:Select(tp,1,1,nil) 
	Duel.SetTargetCard(sg)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,0) 
end 
function c27822029.sbop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 







